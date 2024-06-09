% Representação dos blocos e posições

% Blocos definidos com tamanho (largura, altura)
bloco(a, 1, 1).
bloco(b, 1, 2).
bloco(c, 2, 1).
bloco(d, 2, 2).

% Tamanho dos blocos
tamanho(a, 1, 1).
tamanho(b, 1, 2).
tamanho(c, 2, 1).
tamanho(d, 2, 2).

% Lista de todas as posições possíveis
posicoes([p1, p2, p3, p4, p5, p6]).

% Situações específicas (inicial e final)
s_inicial(i1, s([(c, p1), (a, p4), (b, p5), (d, p6)])).
s_final(i2, s([(a, p2), (b, p3), (c, p4), (d, p1)])).

% Predicado para mover bloco B de P1 para P2 (empilhando se necessário)
move(B, P1, P2, Blocos, NovoBlocos) :-
    write('Tentando mover: '), write((B, P1, P2)), nl,
    select((B, P1), Blocos, RestoBlocos),
    append(RestoBlocos, [(B, P2)], NovoBlocos),
    write('Move: '), write(move(B, P1, P2)), nl.

% Verificar se uma posição está disponível para empilhamento
posicao_disponivel_para_empilhamento(P) :-
    posicoes(Ps),
    member(P, Ps).

% Ação de mover bloco B de P1 para P2 (permitindo empilhamento)
acao(s(Blocos), s(NovoBlocos), move(B, P1, P2)) :-
    write('Tentando ação para: '), write(s(Blocos)), nl, % Depuração
    (member((B, P1), Blocos) ->
        write('Bloco encontrado: '), write((B, P1)), nl ;
        write('Bloco não encontrado: '), write((B, P1)), nl),
    posicoes(Ps),
    member(P2, Ps),
    (P1 \= P2 ->
        write('P1 diferente de P2: '), write((P1, P2)), nl ;
        write('P1 igual a P2: '), write((P1, P2)), nl),
    (posicao_disponivel_para_empilhamento(P2) ->
        write('Posição disponível para empilhamento: '), write(P2), nl ;
        write('Posição não disponível para empilhamento: '), write(P2), nl),
    P1 \= P2,                               % Verifica se P1 é diferente de P2
    posicao_disponivel_para_empilhamento(P2),  % Verifica se P2 está disponível para empilhamento
    move(B, P1, P2, Blocos, NovoBlocos),    % Move B de P1 para P2
    write('Ação encontrada: '), write(move(B, P1, P2)), nl.  % Depuração

% Plano básico (recursivo) para mover blocos evitando estados já visitados
plano(S, S, _, []).
plano(S_inicial, S_final, Visitados, [move(B, P1, P2)|Plano]) :-
    write('Plano atual: '), write(S_inicial), nl, % Depuração
    acao(S_inicial, S_intermediario, move(B, P1, P2)),
    \+ member(S_intermediario, Visitados),
    write('Visitados: '), write(Visitados), nl, % Depuração
    plano(S_intermediario, S_final, [S_intermediario|Visitados], Plano).

% Exemplos de plano de ações
plano_exemplo :-
    s_inicial(i1, S_inicial),
    s_final(i2, S_final),
    plano(S_inicial, S_final, [S_inicial], Plano),
    write('Plano: '), write(Plano), nl.

% Inicialização do plano
inicializa :-
    plano_exemplo.

% Funções de depuração
depurar_acao :-
    s_inicial(i1, S_inicial),
    (acao(S_inicial, S_intermediario, Move) ->
        (write('Move: '), write(Move), nl, write('S_intermediario: '), write(S_intermediario))
    ; write('Nenhuma ação disponível')), nl.

depurar_plano :-
    s_inicial(i1, S_inicial),
    s_final(i2, S_final),
    (plano(S_inicial, S_final, [S_inicial], Plano) ->
        write('Plano: '), write(Plano)
    ; write('Nenhum plano encontrado')), nl.
