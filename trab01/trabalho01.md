# Trabalho 01 - IA

Alunos: Daniel Nunes e Gabriel Assis
Data: 09/06/2024

Link para o Github com os códigos: [dunanes/ufam-ia](https://github.com/dunanes/ufam-ia/tree/main/trab01)

## Mundo dos Blocos

### Explicação

#### 1. Proponha uma linguagem de representação para esta instância do mundo dos blocos

A linguagem de representação escolhida para esta instância do mundo dos blocos inclui detalhes como tamanho do bloco, posição na mesa com medidas de espaço lateral e vertical, condições de vacância para um espaço ser preenchido por um bloco (vertical e horizontal), e estabilidade para um bloco estar sobre outro (vacância no topo e centro de massa em caso de bloco maior sobre menor).

- **Blocos e Lugares:**

  ```prolog
  block(a). block(b). block(c). block(d). block(e).
  place(1). place(2). place(3). place(4). place(5). place(6).
  ```

  Define os blocos e os lugares disponíveis.

- **Tamanho dos Blocos:**

  ```prolog
  size(a, 1). size(b, 2). size(c, 3). size(d, 1). size(e, 2).
  ```

  Define o tamanho de cada bloco em unidades de grade.

- **Condições de Vacância e Estabilidade:**

  ```prolog
  centro_massa(Block, Bi, Bj) :-
      size(Block, Sb),
      size(Bi, Si),
      size(Bj, Sj),
      Sb =< (Si + Sj) + 1.
  ```

  Garante que o centro de massa do bloco superior está alinhado com o bloco inferior.

#### 2. Modificar o código do planner

O código do planner foi modificado para manipular corretamente variáveis sobre goals e também ações conforme a discussão na sessão 17.5.

- **Regras do Planejador:**

  ```prolog
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
  ```

  Define as condições necessárias para mover um bloco de uma posição para outra, incluindo verificações de vacância e estabilidade.

- **Ações de Adicionar e Remover:**

  ```prolog
  adds(move(X, From, To), [on(X, To), clear(From)]).
  deletes(move(X, From, To), [on(X, From), clear(To)]).
  ```

  Especifica os efeitos das ações de mover um bloco.

#### 3. Geração manual do plano de ações

Para a Situação 1, a geração manual dos planos de ações foi feita conforme as seguintes condições iniciais e finais:

- **Estado Inicial: i1 -> Estado Final: i2**

  ```prolog
  inicial([clear(1), clear(2), clear(3), on(a, p([1,2])), on(b, p([2,3])), on(c, p([3,4])), on(d, p([4,5]))]).
  final([clear(1), clear(2), clear(3), on(a, p([4,5])), on(b, p([3,4])), on(c, p([2,3])), on(d, p([1,2]))]).

  plano([
      move(a, p([1,2]), p([4,5])),
      move(b, p([2,3]), p([3,4])),
      move(c, p([3,4]), p([2,3])),
      move(d, p([4,5]), p([1,2]))
  ]).
  ```

  Muda a posição dos blocos conforme necessário para atingir o estado final.

- **Estado Inicial: i2 -> Estado Final: i2 (a)**

  ```prolog
  inicial([clear(1), clear(2), clear(3), on(a, p([4,5])), on(b, p([3,4])), on(c, p([2,3])), on(d, p([1,2]))]).
  final([clear(1), clear(2), clear(3), on(a, p([4,5])), on(b, p([3,4])), on(c, p([2,3])), on(d, p([1,2]))]).

  plano([]).
  ```

  O estado inicial já é igual ao estado final, portanto, não são necessárias ações.

- **Estado Inicial: i2 -> Estado Final: i2 (b)**

  ```prolog
  inicial([clear(1), clear(2), clear(3), on(a, p([4,5])), on(b, p([3,4])), on(c, p([2,3])), on(d, p([1,2]))]).
  final([clear(1), clear(2), clear(3), on(d, p([4,5])), on(c, p([3,4])), on(b, p([2,3])), on(a, p([1,2]))]).

  plano([
      move(d, p([1,2]), p([4,5])),
      move(c, p([2,3]), p([3,4])),
      move(b, p([3,4]), p([2,3])),
      move(a, p([4,5]), p([1,2]))
  ]).
  ```

- **Estado Inicial: i2 -> Estado Final: i2 (b)**

  ```prolog
  inicial([clear(1), clear(2), clear(3), on(d, p([4,5])), on(c, p([3,4])), on(b, p([2,3])), on(a, p([1,2]))]).
  final([clear(1), clear(2), clear(3), on(d, p([4,5])), on(c, p([3,4])), on(b, p([2,3])), on(a, p([1,2]))]).

  plano([]).
  ```

#### 4. Análise das Situações 2 e 3

**Situação 2:**

Para a situação 2, o planejador precisa considerar condições adicionais como:

- **Vacância Horizontal e Vertical:** Verificar se os espaços para mover os blocos estão livres e têm a capacidade de acomodar o tamanho do bloco movido.
- **Estabilidade e Centro de Massa:** Garantir que os blocos maiores sobre menores estão centralizados para manter a estrutura estável.

**Situação 3:**

Para a situação 3, o planejador deve ser capaz de:

- **Manipulação de Blocos Compostas:** Movimentar blocos que possam ter sub-blocos em cima, garantindo a ordem correta de movimentação.
- **Condições Complexas de Estabilidade:** Lidar com situações onde a estabilidade pode ser comprometida se os blocos não estiverem corretamente alinhados.

### Como executar

#### Questão 01

```bash
# Abrir o swipl no terminal
swipl

# Carregar o código
consult('situacao1.pl').

# Executar a consulta
inicial(EstadoInicial), final(EstadoFinal), plano(Plano).
```

#### Questão 02

```bash
# Abrir o swipl no terminal
swipl

# Carregar o código
consult('situacao2.pl').

# Executar a consulta
inicial(EstadoInicial), final(EstadoFinal), plano(Plano).
```

#### Questão 03

```bash
# Abrir o swipl no terminal
swipl

# Carregar o código
consult('situacao3.pl').

# Executar a consulta
inicial(EstadoInicial), final(EstadoFinal), plano(Plano).
```
