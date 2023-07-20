#ifndef __AST_HPP__
#define __AST_HPP__

#include <iostream>
#include <vector>
#include <map>

#include "symbol.hpp"

extern std::vector<int> rt_stack;


class AST {
 public:
  virtual ~AST() = default;
  virtual void sem() {};
  virtual void printAST(std::ostream &out) const = 0;
};

inline std::ostream &operator<<(std::ostream &out, Type t) {
  switch (t) {
    case TYPE_int:  out << "int";  break;
    case TYPE_bool: out << "bool"; break;
  }
  return out;
}

inline std::ostream &operator<<(std::ostream &out, const AST &ast) {
  ast.printAST(out);
  return out;
}

class Decl : public AST {
 public:
  Decl(char v, Type t): var(v), type(t) {}
  void sem() override {
    st.insert(var, type);
  }
  void printAST(std::ostream &out) const override {
    out << "Decl(" << var << ": " << type << ")";
  }
  void allocate() const {
    rt_stack.push_back(0);
  }
  void deallocate() const {
    rt_stack.pop_back();
  }
 private:
  char var;
  Type type;
};

class Stmt : public AST {
 public:
  virtual void execute() const = 0;
};

class Expr : public AST {
 public:
  void check_type(Type t) {
    sem();
    if (type != t) yyerror("Type mismatch");
  }
  virtual int eval() const = 0;
 protected:
  Type type;
};

class If : public Stmt {
 public:
  If(Expr *c, Stmt *s1, Stmt *s2 = nullptr) : cond(c), stmt1(s1), stmt2(s2) {}
  ~If() { delete cond; delete stmt1; delete stmt2; }
  void printAST(std::ostream &out) const override {
    out << "If(" << *cond << ", " << *stmt1;
    if (stmt2 != nullptr) out << ", " << *stmt2;
    out << ")";
  }
  void sem() override {
    cond->check_type(TYPE_bool);
    stmt1->sem();
    if (stmt2 != nullptr) stmt2->sem();
  }
  void execute() const override {
    if (cond->eval())
      stmt1->execute();
    else if (stmt2 != nullptr)
      stmt2->execute();
  }
 private:
  Expr *cond;
  Stmt *stmt1;
  Stmt *stmt2;
};

class Let : public Stmt {
 public:
  Let(char lhs, Expr *rhs): var(lhs), expr(rhs) {}
  ~Let() { delete expr; }
  void printAST(std::ostream &out) const override {
    out << "Let(" << var << ", " << *expr << ")";
  }
  void sem() override {
    STEntry *e = st.lookup(var);
    expr->check_type(e->type);
    offset = e->offset;
  }
  void execute() const override {
    rt_stack[offset] = expr->eval();
  }
 private:
  char var;
  Expr *expr;
  int offset;
};

class Print : public Stmt {
 public:
  Print(Expr *e): expr(e) {}
  ~Print() { delete expr; }
  void printAST(std::ostream &out) const override {
    out << "Print(" << *expr << ")";
  }
  void sem() override {
    expr->check_type(TYPE_int);
  }
  void execute() const override {
    std::cout << expr->eval() << std::endl;
  }
 private:
  Expr *expr;
};

class For : public Stmt {
 public:
  For(Expr *e, Stmt *s): expr(e), stmt(s) {}
  ~For() { delete expr; delete stmt; }
  void printAST(std::ostream &out) const override {
    out << "For(" << *expr << ", " << *stmt << ")";
  }
  void sem() override {
    expr->check_type(TYPE_int);
    stmt->sem();
  }
  void execute() const override {
    for (int times = expr->eval(), i = 0; i < times; ++i)
      stmt->execute();
  }
 private:
  Expr *expr;
  Stmt *stmt;
};

class Block : public Stmt {
 public:
  Block() : decl_list(), stmt_list() {}
  ~Block() {
    for (Decl *d : decl_list) delete d;
    for (Stmt *s : stmt_list) delete s;
  }
  void append_decl(Decl *d) { decl_list.push_back(d); }
  void append_stmt(Stmt *s) { stmt_list.push_back(s); }
  void merge(Block *b) {
    stmt_list = b->stmt_list;
    b->stmt_list.clear();
    delete b;
  }
  void printAST(std::ostream &out) const override {
    out << "Block(";
    bool first = true;
    for (const auto &d : decl_list) {
      if (!first) out << ", ";
      first = false;
      out << *d;
    }
    for (const auto &s : stmt_list) {
      if (!first) out << ", ";
      first = false;
      out << *s;
    }
    out << ")";
  }
  void sem() override {
    st.push_scope();
    for (Decl *d : decl_list) d->sem();
    for (Stmt *s : stmt_list) s->sem();
    st.pop_scope();
  }
  void execute() const override {
    for (Decl *d : decl_list) d->allocate();
    for (Stmt *s : stmt_list) s->execute();
    for (Decl *d : decl_list) d->deallocate();
  }
 private:
  std::vector<Decl *> decl_list;
  std::vector<Stmt *> stmt_list;
};

class BinOp : public Expr {
 public:
  BinOp(Expr *e1, char o, Expr *e2) : expr1(e1), op(o), expr2(e2) {}
  ~BinOp() { delete expr1; delete expr2; }
  void printAST(std::ostream &out) const override {
    out << op << "(" << *expr1 << ", " << *expr2 << ")";
  }
  void sem() override {
    expr1->check_type(TYPE_int);
    expr2->check_type(TYPE_int);
    switch(op) {
      case '+': case '-': case '*': case '/': case '%':
	type = TYPE_int;
        break;
      case '<': case '=': case '>':
	type = TYPE_bool;
        break;
    }
  }
  int eval() const override {
    switch (op) {
      case '+': return expr1->eval() + expr2->eval();
      case '-': return expr1->eval() - expr2->eval();
      case '*': return expr1->eval() * expr2->eval();
      case '/': return expr1->eval() / expr2->eval();
      case '%': return expr1->eval() % expr2->eval();
      case '<': return expr1->eval() < expr2->eval();
      case '=': return expr1->eval() == expr2->eval();
      case '>': return expr1->eval() > expr2->eval();
    }
    return 42;  // will never be reached...
  }
 private:
  Expr *expr1;
  char op;
  Expr *expr2;
};

class Id : public Expr {
 public:
  Id(char c): var(c) {}
  void printAST(std::ostream &out) const override {
    out << "Id(" << var << ")";
  }
  void sem() override {
    STEntry *e = st.lookup(var);
    type = e->type;
    offset = e->offset;
  }
  int eval() const override {
    return rt_stack[offset];
  }
 private:
  char var;
  int offset;
};

class IntConst : public Expr {
 public:
  IntConst(int n): num(n) {}
  void printAST(std::ostream &out) const override {
    out << "IntConst(" << num << ")";
  }
  void sem() override {
    type = TYPE_int;
  }
  int eval() const override {
    return num;
  }
 private:
  int num;
};

class BoolConst : public Expr {
 public:
  BoolConst(int b) : bv(b) {}
  void printAST(std::ostream &out) const override {
    out << "BoolConst(" << bv << ")";
  }
  void sem() override {
    type = TYPE_bool;
  }
  int eval() const override {
    return bv;
  }
 private:
  int bv;
};

#endif
