# apex_strategy

Quadro de estratégia para a polícia. Uma prop (`apx_whiteboard2`), dois
modos, e o que se desenha aparece **na própria prop dentro do jogo**
para toda a gente que estiver na sala.

| Modo | O que é |
|------|---------|
| **Quadro** | whiteboard normal, marcador, formas, texto, marcadores tácticos |
| **Mapa** | o mapa de Los Santos por baixo; desenha-se por cima e fica **colado às coordenadas do mundo** |

---

## Como abrir

`ox_target` na prop, ou **[E]** à frente dela se o target não estiver
instalado. Também há `/quadro`, que abre o mais próximo.

Só quem tem um job de `Config.access.jobs` pode escrever. Ver, vê
quem passar à frente, é um quadro numa sala, não um segredo de
estado.

---

## O modo mapa

O mapa inteiro não cabe num quadro de 1.95 m, e não é isso que se
quer: quer-se **a zona da operação**. O quadro mostra uma janela do
mapa, e o tamanho do ecrã na prop nunca muda.

- **Ferramenta Área** (tecla `0`), arrasta um rectângulo e o quadro
  passa a mostrar exactamente essa zona. É a forma rápida de
  enquadrar um quarteirão.
- **Roda do rato**, zoom para onde o cursor está, não para o centro.
- **Mover** (`9`) ou **Espaço + arrastar**, arrasta o mapa.
- **Zona**, atalhos para Los Santos, Downtown, Vinewood, Porto,
  Aeroporto, Sandy, Paleto, ou o mapa todo.
- **Onde estou** / **Waypoint**, centra na tua posição ou no
  waypoint que tens marcado.

Os tiles vêm de `gtamap.xyz` com a **mesma projecção do
apex_bossmenu**, por isso as coordenadas falam a mesma língua nos dois
scripts. Acima do zoom 5 os tiles são esticados, perde-se nitidez mas
consegue-se enquadrar uma rua.

Como as anotações são guardadas em coordenadas do mundo, um círculo à
volta de um quarteirão continua à volta do quarteirão depois de dares
zoom. Se fossem guardadas em coordenadas do ecrã, escorregavam.

---

## Ferramentas

| Tecla | |
|---|---|
| `S` | **Mexer**, clica para agarrar, arrasta para mover, puxa por um **canto** para redimensionar. `Shift` mantém a proporção. `DEL` apaga |
| `1` | Marcador (mão livre) |
| `2` `3` | Linha · Seta |
| `4` `5` | Rectângulo · Círculo (**Shift** = preenchido) |
| `6` | Texto |
| `7` | Marcador táctico, 31 marcadores em 4 grupos (ver abaixo) |
| `9` | **Medir** distância. No mapa sai em metros, no quadro em percentagem |
| `0` | Apagar (passa por cima) |
| `Ctrl`+`D` | Duplicar o seleccionado |
| `PageUp` / `PageDown` | Trazer para a frente / enviar para trás |
| `9` `0` | Mover o mapa · Enquadrar área *(só no modo mapa)* |
| `Ctrl`+`Z` | anula o teu último |
| `ESC` | fechar |

**Agentes ao vivo**, no modo mapa aparecem os agentes de serviço, com
o nome, a actualizar a cada 3 s. Desliga-se no painel da direita.

### Marcadores tácticos

31 marcadores, desenhados em **vectores** no canvas, nada de fontes de
ícones nem de imagens, porque dentro de um DUI não há garantia nenhuma
de que um recurso externo carregue. A **forma do fundo** diz o grupo,
para se ler de relance sem ter de decifrar o pictograma:

| Grupo | Forma | Marcadores |
|---|---|---|
| **Unidades** | círculo | carro patrulha, descaracterizado, carrinha, mota, helicóptero, barco, canina, SWAT, INEM, bombeiros |
| **Pessoas** | círculo | agente, suspeito, suspeito armado, refém, testemunha, ferido/abatido, atirador |
| **Táctico** | losango | entrada, saída/fuga, cobertura, bloqueio, pregos, perímetro, detenção, perigo, objectivo |
| **Locais** | quadrado | posto/comando, ponto de reunião, câmara, prova, ponto de rádio |

Cada um leva uma **etiqueta** opcional (ex.: `Alfa-1`) e a cor pode ser
trocada na paleta. Acrescentar mais é só uma linha em
`Config.tools.icons`, se o `pic` não existir, cai para a inicial do
nome em vez de partir.

### Tamanhos

O canvas tem 1920 px para 1.95 m de quadro, por isso **1 px ≈ 1 mm
real**. Os traços começavam nos 6 px (6 mm) e não se viam do outro
lado da sala; passaram para `6 · 12 · 22 · 38` com o 12 por omissão.
O texto foi para `44 · 72 · 110 · 160` e os marcadores para 4 cm.
Está tudo em `Config.tools`.

Um **anel** segue o rato com a grossura e a cor escolhidas, para se
ver o traço antes de o fazer. Nas linhas e setas, **Shift** prende o
ângulo a múltiplos de 45°; nos rectângulos e círculos, **Shift**
preenche.

### Texto

Escreve-se **directamente no quadro**: o campo não tem caixa nem fundo,
usa a cor e o tamanho reais, e cresce com o que se escreve. `Enter`
grava, `Esc` cancela, clicar fora grava o que já lá está.

O **contorno** por trás do texto está desligado por omissão (texto
pelado). Liga-o no painel quando escreveres por cima do mapa, onde o
fundo é irregular e sem ele perde-se.

---

### Passos numerados

O marcador **Passo** numera-se sozinho: conta os que já estão no
quadro e continua a sequência. Serve para escrever a ordem de uma
entrada (1 arrombar, 2 cobrir, 3 avançar) sem andar a escrever
números à mão.

### Trancar o quadro

Um supervisor pode **trancar** o quadro pelo botão no topo. Congela
tudo durante uma operação a decorrer sem ser preciso tirar o serviço
a ninguém: quem não é supervisor continua a ver, mas não mexe. Os
outros vêem um aviso a dizer porquê.

## Quem pode o quê

- **Escrever**, qualquer job em `Config.access.jobs`.
- **Apagar**, cada um apaga o que escreveu. O "Limpar" de um agente
  normal só leva o que é dele.
- **Supervisor** (`grade >= Config.access.supervisorGrade`, ou `isboss`)
 , apaga tudo e muda o nome do quadro.

O servidor revalida **em cada operação**: o job, e que estás mesmo ao
pé do quadro. O cliente diz em que quadro está a mexer, mas não é
por dizer que é aceite.

---

## Pôr e tirar quadros

Podes ter **quantos quiseres**. Cada um tem o seu id, o seu nome e o
seu conteúdo, e todos ficam gravados na base de dados: sobrevivem ao
restart e aparecem a toda a gente.

Duas maneiras, ambas só para quem tem permissão de admin:

**Pelo editor** (secção *Administração*, no fundo do painel direito):
- **Pousar outro quadro** fecha o editor e entra logo em modo de
  posicionamento.
- **Apagar este quadro** pede confirmação e apaga a prop e tudo o que
  lá estava escrito.

**Por comando**: `/wb` para pousar, `/wbdel` para apagar o mais
próximo, `/wbmove` para o arrumar noutro sítio.

> A secção de administração só aparece a quem passa no `Config.ace`.
> Pousar e apagar quadros é gestão do servidor, não galões de
> esquadra: um chefe escreve no quadro, mas não decide onde ele fica.

## Admin

| Comando | |
|---------|--|
| `/wb` | pousar um quadro novo (fica gravado na base de dados) |
| `/wbmove` | voltar a arrumar o mais próximo |
| `/wbdel` | apagar o mais próximo |
| `/wbname <nome>` | mudar o nome |
| `/wbanim` | liga/desliga a animação de escrever no personagem |
| `/wbcal` | calibrar o ecrã sobre a prop |
| `/wbprint` · `/wbmode` | ver os valores da calibração · trocar scaleform/poly |

Posicionamento: rato aponta · **roda** roda 5° por entalhe (**Shift**
45°) · **← →** 1° · **↑ ↓** altura · **Ctrl+roda** alcance · **clique
esquerdo** confirma.

---

## Como o ecrã chega à prop

O mesmo pipeline da TV do dyno do `apex_obd`:

```
CreateDui(board.html)
  → CreateRuntimeTextureFromDuiHandle
  → scaleform SET_TEXTURE
  → DrawScaleformMovie_3dNonAdditive todos os frames
```

O editor (NUI) e o ecrã da prop (DUI) usam **o mesmo renderizador**
(`html/js/board.js`) e o mesmo tamanho de canvas (1920 × 1164). É isso
que garante que uma linha de 6 px no editor é uma linha de 6 px no
quadro lá fora.

DUIs são caros: só os `Config.render.maxLiveScreens` quadros mais
próximos têm ecrã montado; os outros ficam só com a prop.

### O que a calibração ensinou (26 jul 2026)

Dois quadros calibrados em separado, com orientações diferentes, deram
resultados que se cruzam:

**A posição do `DrawScaleformMovie_3dNonAdditive` é o canto superior
esquerdo do rectângulo, não o centro.** Quatro eixos independentes
caíram na meia-medida do painel.

**O quadro-base do `.gfx` é achatado 4.44:1.**

```
whiteboard2 :  X 36.2328   Z 8.1611   →  aspect 4.4397
whiteboard1 :  X 36.9614   Z 8.3282   →  aspect 4.4381
                                          discrepância 0.04%
```

`Config.render.metersPerUnit = { x = 36.5971, z = 8.2447 }` (a média).
Aplicado aos valores do `prop_tv_stand_01` no apex_obd isto dá um
televisor de 2.31 × 0.41 m, ou seja, **a TV do dyno nunca esteve bem
calibrada**. Não é problema nosso, mas explica porque é que qualquer
semente tirada de lá saía tão longe.

Para uma prop nova: `/wbcal` → **F** encaixa com estas constantes; se
não bater, **T** abre o modo medir (arrasta-se um rectângulo sobre a
imagem e o script calcula a escala e descobre a âncora sozinho).

---

## Sincronização e persistência

O servidor é a fonte de verdade. O cliente manda operações (um traço
completo, não ponto a ponto), o servidor valida e reemite **só para
quem está no raio do quadro**, não vale a pena acordar a cidade por
causa de um quadro dentro da esquadra.

### Como se evita o eco duplicado

O editor pinta tudo **de imediato** (senão um traço desaparecia
durante a ida e volta ao servidor). Mas a difusão do servidor volta
para toda a gente, incluindo o autor, e aplicada outra vez punha lá
tudo em duplicado. Daí em diante apagar levava as duas cópias e mover
deslocava só uma: era isto que fazia o quadro parecer avariado.

Duas medidas resolvem-no:

- **O id do item é escolhido pelo cliente**, não pelo servidor. A
  difusão traz o mesmo id, a verificação de duplicado apanha-o, e não
  é preciso renomear nada a meio da operação.
- **Cada operação leva um bilhete** (`tok`) que o servidor devolve na
  difusão. O autor reconhece o seu próprio eco e ignora-o.

O caminho do ecrã na prop (Lua → DUI) aplica a difusão normalmente -
esse não pintou nada localmente.

Persistência em MySQL (`oxmysql`), em lote de 15 em 15 segundos e no
encerramento do resource, um traço não vale uma ida à base de dados.
As tabelas são criadas no arranque; o `sql/install.sql` está lá para
quem prefere correr o SQL à mão.

Sem base de dados o script continua a funcionar: os quadros vivem em
memória do servidor e perdem-se no restart.

---

## Ficheiros

```
shared/config.lua        jobs, ferramentas, mapa, calibração
shared/framework.lua     ESX / QBCore / QBox
shared/integrations.lua  hooks para ligares ao teu ecossistema
client/screen.lua        DUI + scaleform na prop
client/boards.lua        streaming das props e do conteúdo
client/nui.lua           ponte editor ↔ servidor
client/place.lua         posicionar a prop
client/calibrate.lua     calibrar o ecrã
server/main.lua          validação, difusão, admin
html/js/board.js         o renderizador (partilhado NUI + DUI)
html/js/app.js           o editor
html/js/dui.js           o ecrã da prop
```

---

## Instalação

1. Pousa a pasta `apex_strategy` em `resources/` e acrescenta
   `ensure apex_strategy` ao `server.cfg` (depois do `oxmysql`).
   As props dos quadros (`apx_whiteboard1/2`) e os scaleforms já vêm
   dentro do próprio script, em `stream/` — não há mais nada para
   instalar.
2. Restart **completo** do servidor na primeira vez (os ficheiros em
   `stream/` — props e `.gfx` — só são registados assim).
3. `/wb` para pousar o primeiro quadro.
