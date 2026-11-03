# Troubleshooting — v0.4.0

[English](troubleshooting-v0.4.0.md)

Problemas encontrados durante a integração física do Galaxy S10+ no gabinete da versão v0.4.0 do Linudex, incluindo diagnósticos, soluções aplicadas e limitações conhecidas.

Problemas de software documentados nas versões anteriores não são repetidos aqui, exceto quando relacionados diretamente à montagem física.

## Índice de problemas

- [Botão Power pressionado pelo suporte](#botão-power-pressionado-pelo-suporte-do-gabinete)
- [Porta USB-C secundária do hub não carregava o smartphone](#porta-usb-c-secundária-do-hub-não-carregava-o-smartphone)
- [Conector P2 recuava ao conectar um fone](#conector-p2-recuava-ao-conectar-um-fone)
- [Botões de volume e Bixby parcialmente pressionados](#botões-de-volume-e-bixby-ficaram-parcialmente-pressionados)
- [Ausência de botão Power externo](#gabinete-não-tem-botão-power-externo)

---

## Botão Power pressionado pelo suporte do gabinete

### Sintomas

Na posição inicialmente utilizada para instalar o Galaxy S10+ no mini gabinete, o suporte de fixação, ajustado por um parafuso, exercia pressão sobre o botão lateral Power. A intensidade da pressão variava conforme o aperto do suporte.

Isso poderia provocar acionamentos involuntários e aumentar o risco de desgaste ou dano físico ao botão.

### Diagnóstico

O problema era causado pela posição do smartphone em relação à parede interna e ao ponto de fixação do gabinete, e não por falha no Android ou no botão Power.

A conexão direta do USB-C ao hub limitava as possibilidades de reposicionamento do aparelho.

### Solução

Foi adquirido um **extensor USB-C macho → fêmea**, utilizado entre o Galaxy S10+ e o hub USB-C. O cabo permitiu inverter o posicionamento do smartphone e deixar o botão Power fora da área de pressão do suporte, sem exigir alterações estruturais no gabinete.

### Validação

O extensor funcionou com o hub no conjunto testado, permitindo manter a conexão do smartphone após o reposicionamento. O botão Power deixou de ser pressionado pelo suporte na nova posição.

### Estado

**Resolvido na montagem atual.**

---

## Porta USB-C secundária do hub não carregava o smartphone

### Sintomas

Ao conectar o carregador a uma das duas portas USB-C fêmea do hub, o LED indicador acendia, mas o Galaxy S10+ não recebia carga por essa conexão.

### Diagnóstico

O manual do hub esclareceu que as duas portas possuem funções diferentes:

```text
USB-C female port 1: PD input (20V@3A; adapter up to 87W, conforme manual)
USB-C female port 2: High Speed USB-C; peripheral power up to 4.5W
```

A segunda porta é destinada à conexão de periféricos USB-C e pode fornecer energia a eles; não é uma segunda entrada de alimentação PD para o smartphone. O LED aceso, isoladamente, não confirma carregamento do aparelho.

### Solução

O carregador deve ser ligado à **primeira porta USB-C fêmea (PD-IN)**. A segunda permanece disponível para periféricos USB-C compatíveis.

### Estado

**Comportamento esclarecido pelo manual; não era defeito confirmado do hub.**

---

## Conector P2 recuava ao conectar um fone

### Sintomas

Uma extensão de áudio P2 de 3,5 mm e 50 cm foi instalada para levar a saída do Galaxy S10+ a uma abertura traseira do gabinete, acima da porta Ethernet do hub.

A fixação inicial com fita isolante não impedia que o jack fêmea fosse empurrado para dentro do gabinete durante a inserção de um plugue.

### Diagnóstico

A fita mantinha a posição aproximada do cabo, mas não fornecia retenção axial suficiente para resistir à força exercida ao conectar um fone.

### Solução

Foi construído um suporte de retenção com arruelas de borracha de diferentes tamanhos, coladas umas às outras com cianoacrilato (Super Bonder). Um pincel foi utilizado como referência para calibrar a abertura central do conjunto.

O procedimento incluiu:

- Colagem e alinhamento das arruelas em torno do pincel.
- Expansão gradual do encaixe para que o jack P2 entrasse de maneira justa.
- Fixação do conjunto de arruelas à parede interna do gabinete com cianoacrilato.
- Cura da montagem por aproximadamente 24 horas.
- Acabamento externo com pequenos pedaços de fita isolante para cobrir marcas de cola.

### Validação

O jack passou a ficar firmemente posicionado na abertura traseira, sem o recuo observado anteriormente. O conector continua removível, embora o encaixe seja bastante justo.

### Estado

**Resolvido na montagem atual.**

---

## Botões de volume e Bixby ficaram parcialmente pressionados

### Sintomas

Após inverter a posição do Galaxy S10+ para liberar o botão Power, o suporte do gabinete passou a exercer alguma pressão sobre os botões laterais de volume e Bixby.

### Diagnóstico

A limitação decorre do espaço e da geometria de fixação disponíveis dentro do mini gabinete. O reposicionamento priorizou deixar o botão Power livre.

### Decisão adotada

A montagem foi mantida nessa posição por enquanto. Não foi relatada falha funcional decorrente dessa pressão, mas ela deve ser verificada durante o uso: botões continuamente pressionados podem provocar ações indesejadas ou desgaste.

### Estado

**Limitação conhecida da montagem atual; sem correção adicional implementada.**

---

## Gabinete não tem botão Power externo

### Situação

O gabinete não oferece um acionador externo dedicado ao botão Power do Galaxy S10+. Na disposição atual, o botão físico do smartphone não é convenientemente acessível com o conjunto montado.

### Diagnóstico

Uma extensão mecânica do acionamento exigiria espaço adicional ou modificações na estrutura do gabinete. A alternativa de interferir eletricamente no botão do smartphone não foi adotada.

### Decisão adotada

O projeto permanece sem botão Power externo na v0.4.0. Para o uso cotidiano, é possível manter o Android ligado e iniciar ou encerrar apenas o ambiente Linudex, evitando desligamentos completos desnecessários.

Essa abordagem não substitui o acesso físico ao botão em situações de travamento, desligamento completo ou manutenção.

### Estado

**Limitação de projeto aceita na v0.4.0; possível melhoria futura.**
