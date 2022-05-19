# ag_custo

Desenvolvido por Patrick de Oliveira Rosa Staroin (1687760).

Aplicativo que busca facilitar a adição de novos custos de cada veículo do estoque. Baseado em um sistema já existente chamado AutoGestor.

Atualmente o estoque de veículos ainda é estático, mas posteriormente serão carregados à partir da API do AutoGestor.
O aplicativo possui login por email, utilizando a ferramenta de autenticação do Firebase. Não existe possibilidade de criar nova conta, visto que o aplicativo só será usado por empresas que pagam a mensalidade do sistema.

Para testes, é utilizado o seguinte email:
teste@teste.com
Senha: teste1

O aplicativo usa apenas o banco de dados do Firestore e, por enquanto, salva apenas dados de custo dos carros.
Posteriormente será utlizado o Cloud Storage, para guardar fotos tiradas no aplicativo.

Por enquanto o Firebase está configurado apenas para Android, visto que não tenho meios para testá-lo no iOS.
