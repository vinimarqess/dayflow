create database dayflow;
use dayflow;

create table usuario (
    id_usuario int auto_increment primary key,
    nome_usuario varchar(150) not null,
    email varchar(150) not null unique,
    senha varchar(255) not null
);

create table evento (
    id_evento int auto_increment primary key,
    nome varchar(100) not null,
    descricao varchar(255),
    data date not null,
    hora time not null,
    alarme time,
    id_usuario int not null,
    foreign key (id_usuario) references usuario(id_usuario)
);

create table rotina (
    id_rotina int auto_increment primary key,
    nome varchar(100) not null,
    descricao varchar(255),
    id_usuario int not null,
    foreign key (id_usuario) references usuario(id_usuario)
);

create table diasemana (
    id_diasemana int auto_increment primary key,
    nome varchar(50) not null,
    id_rotina int not null,
    foreign key (id_rotina) references rotina(id_rotina)
);

create table habito (
    id_habito int auto_increment primary key,
    nome varchar(100) not null,
    horario_inicio time not null,
    horario_fim time not null,
    id_diasemana int not null,
    foreign key (id_diasemana) references diasemana(id_diasemana)
);