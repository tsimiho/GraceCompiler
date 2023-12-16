#ifndef __AST_HPP__
#define __AST_HPP__

#include <iostream>
#include <map>
#include <string>
#include <variant>
#include <vector>

#include "symbol.hpp"

void yyerror(const char *msg);

inline std::ostream &operator<<(std::ostream &out, Type t) {
  switch (t) {
  case TYPE_int:
    out << "int";
    break;
  case TYPE_char:
    out << "char";
    break;
  }
  return out;
}

class AST {
public:
  virtual ~AST() {}
  virtual void printOn(std::ostream &out) const = 0;
  virtual void sem() {}
};

inline std::ostream &operator<<(std::ostream &out, const AST &t) {
  t.printOn(out);
  return out;
}

class Expr : public AST {
public:
  virtual std::variant<int, char> eval() const = 0;
  void type_check(Type t) {
    sem();
    if (type != t)
      yyerror("Type mismatch");
  }

protected:
  Type type;
};

class Stmt : public AST {
public:
  virtual void run() const = 0;
};

extern std::vector<int> rt_stack;

// Expressions

class Id : public Expr {
public:
  Id(char v) : var(v), offset(-1) {}
  virtual void printOn(std::ostream &out) const override {
    out << "Id(" << var << "@" << offset << ")";
  }
  virtual std::variant<int, char> eval() const override {
    return rt_stack[offset];
  }
  virtual void sem() override {
    SymbolEntry *e = st.lookup(var);
    type = e->type;
    offset = e->offset;
  }

private:
  char var;
  int offset;
};

class Const : public Expr {
public:
  Const(int n) : num(n) {}
  virtual void printOn(std::ostream &out) const override {
    out << "IntConst(" << num << ")";
  }
  virtual std::variant<int, char> eval() const override { return num; }
  virtual void sem() override { type = TYPE_int; }

private:
  int num;
};

class CharConst : public Expr {
public:
  CharConst(char c) : ch(c) {}
  virtual void printOn(std::ostream &out) const override {
    out << "CharConst(" << ch << ")";
  }
  virtual std::variant<int, char> eval() const override { return ch; }
  virtual void sem() override { type = TYPE_char; }

private:
  char ch;
};

class BinOp : public Expr {
public:
  BinOp(Expr *l, std::string o, Expr *r) : left(l), op(o), right(r) {}
  ~BinOp() {
    delete left;
    delete right;
  }
  virtual void printOn(std::ostream &out) const override {
    out << op << "(" << *left << ", " << *right << ")";
  }
  virtual std::variant<int, char> eval() const override {
    switch (op) {
    case "+":
      return left->eval() + right->eval();
    case "-":
      return left->eval() - right->eval();
    case "*":
      return left->eval() * right->eval();
    case "div":
      return left->eval() / rigth->eval();
    case "mod":
      return left->eval() % rigth->eval();
    }
    return 42; // this will never be reached.
  }
  virtual void sem() override {
    left->type_check(TYPE_int);
    right->type_check(TYPE_int);
    switch (op) {
    case "+":
    case "-":
    case "*":
    case "div":
    case "mod":
      type = TYPE_int;
      break;
    }
  }

private:
  Expr *left;
  std::string op;
  Expr *right;
};

class Cond : public Expr {
public:
  Cond(Expr *l, std::string o, Expr *r) : left(l), op(o), right(r) {}
  ~Cond() {
    delete left;
    delete right;
  }
  virtual void printOn(std::ostream &out) const override {
    out << op << "(" << *left << ", " << *right << ")";
  }
  virtual bool eval() const override {
    switch (op) {
    case "=":
      return left->eval() == right->eval();
    case "#":
      return left->eval() != right->eval();
    case "<":
      return left->eval() < right->eval();
    case ">":
      return left->eval() > rigth->eval();
    case "<=":
      return left->eval() <= rigth->eval();
    case ">=":
      return left->eval() >= rigth->eval();
    }
    return 42; // this will never be reached.
  }

private:
  Expr *left;
  std::string op;
  Expr *right;
};

// Statements

class Assign : public Stmt {
public:
  Assign(LValue *l, Expr *e) : lval(l), expr(e) {}
  ~Assign() {
    delete lval;
    delete expr;
  }
  virtual void printOn(std::ostream &out) const override {
    out << "Assign(" << *lval << ", " << *expr << ")";
  }
  virtual void run() const override {
    SymbolEntry *lhs = st.lookup(var);
    expr->type_check(lhs->type);
    offset = lhs->offset;
  }
  virtual void sem() override {}

private:
  LValue *lval;
  int offset;
  Expr *expr;
};

class If : public Stmt {
public:
  If(Expr *c, Stmt *s1, Stmt *s2 = nullptr) : cond(c), stmt1(s1), stmt2(s2) {}
  ~If() {
    delete cond;
    delete stmt1;
    delete stmt2;
  }
  virtual void printOn(std::ostream &out) const override {
    out << "If(" << *cond << ", " << *stmt1;
    if (stmt2 != nullptr)
      out << ", " << *stmt2;
    out << ")";
  }
  virtual void run() const override {
    if (cond->eval())
      stmt1->run();
    else if (stmt2 != nullptr)
      stmt2->run();
  }
  virtual void sem() override {
    // cond->type_check(TYPE_char);
    stmt1->sem();
    if (stmt2 != nullptr)
      stmt2->sem();
  }

private:
  Expr *cond;
  Stmt *stmt1;
  Stmt *stmt2;
};

class While : public Stmt {
public:
  While(Cond *c, Stmt *s) : cond(c), stmt(s) {}
  ~While() {
    delete cond;
    delete stmt;
  }
  virtual void printOn(std::ostream &out) const override {
    out << "While(" << *expr << ", " << *stmt << ")";
  }
  virtual void run() const override {
    while (cond->eval()) {
      stmt->run();
    }
  }

private:
  Cond *cond;
  Stmt *stmt;
};

class Return : public Stmt {
public:
  Return(Expr *e = nullptr) : expr(e) {}
  ~Return() { delete expr; }
  virtual void printOn(std::ostream &out) const override {
    out << "Return(";
    if (stmt2 != nullptr)
      out << *stmt2;
    out << ")";
  }
  virtual void run() const override { return expr->eval(); }

private:
  Expr *expr;
};

#endif
