% Definição dos blocos e lugares
block(a). block(b). block(c). block(d). block(e).
place(1). place(2). place(3). place(4). place(5). place(6).

% Tamanho dos blocos
size(a, 1). size(b, 2). size(c, 3). size(d, 1). size(e, 2).

% Estado final de exemplo
final([clear(1), clear(2), clear(3), on(d, p([4,6])), on(c, p([d,d])), on(a, c), on(b, c)]).

% Regras do planejador
can(move(Block, p([Oi,Oj]), p([Bi,Bj])), [clear(Block), clear(Bi), clear(Bj), on(Block, p([Oi,Oj]))]):-
    block(Block),
    block(Bi),
    block(Bj),
    Bi \== Block,
    block(Oi), block(Oj),
    Oi \== Bi,
    Oj \== Bj,
    Block \== Oi,
    size(Block, Sb),
    size(Bi, Si),
    size(Bj, Sj),
    SizeTo is Si + Sj,
    Sb =< SizeTo + 1,
    centro_massa(Block, Bi, Bj).

can(move(Block, p([Oi,Oj]), p(B,B)), [clear(Block), clear(B), on(Block, p([Oi,Oj]))]):-
    block(Block),
    block(B),
    B \== Block,
    block(Oi), block(Oj),
    Oi \== B,
    Oj \== B,
    size(Block, SizeB),
    size(B, Sb),
    SizeB =< Sb + 2,
    centro_massa(Block, B).

can(move(Block, From, To), [clear(Block), clear(To), on(Block, From)]):-
    block(Block),
    object(To),
    To \== Block,
    object(From),
    From \== To,
    Block \== From.

adds(move(X, From, To), [on(X, To), clear(From)]).

deletes(move(X, From, To), [on(X, From), clear(To)]).

object(X):- place(X); block(X).

impossible(on(X,X), _).
impossible(on(X, Y), Goals):-
    member(clear(Y), Goals);
    member(on(X, Y1), Goals), Y1 \== Y;
    member(on(X1, Y), Goals), X1 \== X.
impossible(clear(X), Goals):-
    member(on(_, X), Goals).

centro_massa(Block, Bi, Bj) :-
    size(Block, Sb),
    size(Bi, Si),
    size(Bj, Sj),
    Sb =< (Si + Sj) + 1.

% Exemplo de geração manual de planos de ações

% Situação 1
% Estado Inicial: i1 -> Estado Final: i2
inicial([clear(1), clear(2), clear(3), on(a, p([1,2])), on(b, p([2,3])), on(c, p([3,4])), on(d, p([4,5]))]).
final([clear(1), clear(2), clear(3), on(a, p([4,5])), on(b, p([3,4])), on(c, p([2,3])), on(d, p([1,2]))]).

plano([
    move(a, p([1,2]), p([4,5])),
    move(b, p([2,3]), p([3,4])),
    move(c, p([3,4]), p([2,3])),
    move(d, p([4,5]), p([1,2]))
]).

% Estado Inicial: i2 -> Estado Final: i2 (a)
inicial([clear(1), clear(2), clear(3), on(a, p([4,5])), on(b, p([3,4])), on(c, p([2,3])), on(d, p([1,2]))]).
final([clear(1), clear(2), clear(3), on(a, p([4,5])), on(b, p([3,4])), on(c, p([2,3])), on(d, p([1,2]))]).

plano([]).

% Estado Inicial: i2 -> Estado Final: i2 (b)
inicial([clear(1), clear(2), clear(3), on(a, p([4,5])), on(b, p([3,4])), on(c, p([2,3])), on(d, p([1,2]))]).
final([clear(1), clear(2), clear(3), on(d, p([4,5])), on(c, p([3,4])), on(b, p([2,3])), on(a, p([1,2]))]).

plano([
    move(d, p([1,2]), p([4,5])),
    move(c, p([2,3]), p([3,4])),
    move(b, p([3,4]), p([2,3])),
    move(a, p([4,5]), p([1,2]))
]).

% Estado Inicial: i2 -> Estado Final: i2 (b)
inicial([clear(1), clear(2), clear(3), on(d, p([4,5])), on(c, p([3,4])), on(b, p([2,3])), on(a, p([1,2]))]).
final([clear(1), clear(2), clear(3), on(d, p([4,5])), on(c, p([3,4])), on(b, p([2,3])), on(a, p([1,2]))]).

plano([]).

% Análise das Situações 2 e 3

% Situação 2
% Condições adicionais a serem consideradas para gerar planos de ações de S0 até o estado final
% - Vacância Horizontal e Vertical
% - Estabilidade e Centro de Massa

% Situação 3
% Condições adicionais a serem consideradas para gerar planos de ações de S0 até o estado final
% - Manipulação de Blocos Compostas
% - Condições Complexas de Estabilidade
