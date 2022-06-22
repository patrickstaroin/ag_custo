# ag_custo

Desenvolvido por Patrick de Oliveira Rosa Staroin (1687760).

Aplicativo que busca facilitar a adição de novos custos de cada veículo do estoque. Baseado em um sistema já existente chamado AutoGestor.

Não existe possibilidade de criar nova conta, visto que o aplicativo só será usado por empresas que pagam a mensalidade do sistema. O estoque de veículos (informações e fotos) é atualizado de acordo com a API do sistema AutoGestor, enquanto que o custo dos carros é armazenado apenas no Firestore, pois a API não dá acesso à parte financeira. Novos carros adicionados ficam salvos apenas na base de dados do Firestore, para não afetar o uso real do sistema.

As fotos que retornam da API são salvas no Firebase Storage, para posteriormente o aplicativo realizar a leitura dessas fotos, mantendo consistência.

Para testes, é utilizado o seguinte email:
staroin.oficina@hotmail.com
Senha: palio2014

Por enquanto o Firebase está configurado apenas para Android, visto que não realizei testes no iOS.
