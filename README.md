Bem vindo ao Talkworking
========================
***

Talkworking é um gerenciador de tarefas, focado em ser simples e objetivo, fazendo com que controlar tarefas não seja algo cansativo ou chato.

Escrito em Ruby on Rails e sendo open source está atualmente hospedado no heroku http://talkworking.herokuapp.com onde qualquer usuário pode usá-lo sem pagar nada.

Especificações
==============
***

Por estar hospedado no heroku o talkworing usa o banco de dados postgres,  mas caso você queira contribuir com o projeto, fique a vontade para usar o banco que se sentir  mais a vontade, só cuidado ao commitar o arquivo database.yml.


O talkworking é composto pela seguinte estrutura:

* - Usuário
* - Comentário
* - Histórico
* - Sugestão
* - Projeto
* - - Tipo de tarefa
* - - Status (Coluna)
* - - Lista de tarefa
* - - - Tarefa

E para o seu layout foi usado o bootstrap (http://twitter.github.com/bootstrap/)

Os testes atualmente estão escritos a API padrão do Rails, porém já há uma tarefa associado ao projeto para ser migrado os testes para RSPEC.

Contribuindo
============
***

A idéia do projeto, não é ser pago, chato ou qualquer coisa assim, a idéia é criar uma ferramenta para gerenciamento de tarefas, focado em agilidade, simplicidade e que deixe nosso dia-a-dia mais fácil e divertido, não queremos uma ferramenta do tamanho do JIRA ou então tão complexa quanto o qualitor, não precisamos disso, particularmente, detestamos elas...

Então se quiser contribuir com o talkworking é necessário criar um fork do repositório e executar os comandos:
	- bundle install
	- rake db:create
	- rake db:migrate
	- rake db:seed

	credenciais:
		admin@admin.com
		123456

**Você precisará mudar o banco de dados usados, caso utilize um diferente do postgres**

As tarefas são gerenciadas tanto pelo http://talkworking.herokuapp.com quanto por issues do github, você usar o github para gerenciar as tarefas, ou então usar o próprio talkworking, caso a ultima opção seja a sua escolha, mande um e-mail para talkworking@gmail.com, que iremos convidá-lo a participar do projeto.


Um grande abraço.

Imagens
==============
***

![Meus Projetos](https://raw.github.com/leonardoprg/talkworking/master/public/talkworking/projetos.png)

***

![Gerencia projeto](https://raw.github.com/leonardoprg/talkworking/master/public/talkworking/show_projeto.png)

***

![Editar tarefa](https://raw.github.com/leonardoprg/talkworking/master/public/talkworking/edit_tarefa.png)

***

![Quadro de kanban](https://raw.github.com/leonardoprg/talkworking/master/public/talkworking/kanban.png)