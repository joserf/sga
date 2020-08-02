# sga
Novo SGA em Docker - Sistema de Gerenciamento de Atendimento (BD Externo)

    1- Faça o download dos arquivos no seu servidor Docker.
 
    2- Edite as linhas 8, 9, 10, 11, 12 do Dockerfile, adicionando suas credenciais do banco de dados externo.
    
    3- No seu servidor de banco de dados externo, importe o banco de dados "novosga.sql"
    
    Dica: grant all privileges on novosga.* to novosga@localhost identified by 'sga123';
    GRANT ALL ON novosga.* TO 'novosga'@'IP-SERVIDOR-DOCKER' IDENTIFIED BY 'sga123' WITH GRANT OPTION;
    flush privileges;
 
    4- Faça o build. 
    
    # docker build -t novosga .
    
    5- Execute o container.
    
    # docker run --name Novo-Sga -p 8080:80 -d novosga
    
    6- Acessando a aplicação.
    
    http://IP-SERVIDOR-DOCKER:8080 (Login: admin | Senha: sga123)
    
    Acessando o painel web.
    
    http://IP-SERVIDOR-DOCKER:8080/painel-web
    
    Acessando a triagem touch.
    
    http://IP-SERVIDOR-DOCKER:8080/triagem-touch
    
     
