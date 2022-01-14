# TD2 Base de données

## B/ Dictionnaire des donées sur les privilèges

**3)** Que fait la requête

```sql
select 'Connecté ' || sys_context('USERENV','OS_USER'), 
UID , USER ,SYSDATE , SYSTIMESTAMP, bitand(170,102)
from DUAL
```

Elle affiche quand l'utilisateur de l'ordinateur s'est connecté avec quel utilisateur de la BD.

```sql
describe DUAL
```

```
Nom   NULL ? Type        
----- ------ ----------- 
DUMMY        VARCHAR2(1) 
```

DUMMY = factice (La table DUAL n'existe pas vraiment)

**4)** Afficher les privilèges de ETDDBA

```sql
select * from DBA_SYS_PRIVS where grantee = 'ETDDBA'
```

```sql
select * from DBA_SYS_PRIVS where grantee = 'ETD'
```

```
ETD    SELECT ANY TABLE        NO    NO
ETD    CREATE SESSION            NO    NO
ETD    SELECT ANY DICTIONARY    NO    NO
```

**5)** Afficher tous les privilèges systèmes de l'utilisateur DBA que n'a pas l'utilisateur ETDDBA

```sql
select * from DBA_SYS_PRIVS where grantee = 'DBA'
minus
select * from DBA_SYS_PRIVS where grantee = 'ETDDBA';
```

**6)** Afficher les privilèges objets (Tables et privilèges associés) attribués à ETD par ADMIN

```sql
select * from DBA_TAB_PRIVS where grantee = 'ETD' and grantor = 'ADMIN';
```

```sql
select * from DBA_TAB_PRIVS where grantee = 'ETDDBA' and grantor = 'ADMIN';
```

Droits de `ETD` sur `RESERVATION` :

- INSERT

- DELETE

- SELECT

- UPDATE

Droits de `ETD` sur `ACTEUR` :

- SELECT

**7)** Créer une nouvelle table

```sql
create table test_table (
champ number
);
```

```sql
drop table test_table;
```

**8)** Essayer de supprimer `reservation`

```sql
drop table reservation;
```

## C / Création d'utilisateur

**9)** Créer un nouvel utilisateur

```sql
create user ETD_RIBOULET identified by ETD_RIBOULET;
```

**10)** Afficher le nouvel utilisateur

```sql
select * from ALL_USERS where username = 'ETD_RIBOULET';
```

![](./assets/2022-01-05-14-20-35-image.png)

**11)** Connexion au nouvel utilisateur

![](./assets/2022-01-05-14-24-14-image.png)

Mais l'utilisateur na pas les droits de se connecter

![](./assets/2022-01-05-14-27-30-image.png)

## D) Attribution de privilièges

**13)** Afficher tous les provilèges systèmes de l'utilisateur

```sql
select * from DBA_SYS_PRIVS where grantee = 'ETD_RIBOULET';
```

> L'utilisateur a aucun droits

**14)** Assignation des privilèges

```sql
GRANT 
SELECT ANY TABLE,
SELECT ANY DICTIONARY,
CREATE SESSION,
ALTER SESSION,
CREATE TABLE,
CREATE VIEW, 
CREATE PROCEDURE, 
CREATE TRIGGER,
CREATE SEQUENCE,
UNLIMITED TABLESPACE 
TO ETD_RIBOULET;
```

```sql
select * from DBA_SYS_PRIVS where grantee = 'ETD_RIBOULET';
```

![](./assets/2022-01-05-14-40-23-image.png)

**15)** Ouvrir une connexion avec `ETD_CRIBOULET`

> Comme question 11 mais cette fois ci on peut se connecter

## E/ Définition des données

> A partir de maintenant on est connecté sur le compte `ETD_CRIBOULET`

**17)** Créer une table

```sql
create table ETD_RIBOULET_CPV (
    CodePostal CHAR(5) NOT NULL,
    Ville VARCHAR(30),
    CONSTRAINT PK_RIBOULET_CPV PRIMARY KEY(CodePostal)
);
```

## F/ Gestion des privilèges

**18)** Insérer ville de Gradignan (33170) et Paris (75000) dans la table `ETD_RIBOULET_CPV` 

```sql
insert into ETD_RIBOULET_CPV values ('33170', 'Gradignan');
insert into ETD_RIBOULET_CPV values ('75000', 'Paris');
```

**19)** Créer une vue permettant d'afficher touts les informations de la table `ETD_RIBOULET_CPV`

```sql
create view ETD_RIBOULET_CPV_GIRONDE AS 
select * from ETD_RIBOULET_CPV where CodePostal like '33%';
```

```sql
select * from ETD_RIBOULET_CPV_GIRONDE;
```

**20)** Accorder à ETD les privilèges 

- `INSERT` et `SELECT` sur `ETD_RIBOULET_CPV`
  
  - ```sql
    grant SELECT, INSERT on ETD_RIBOULET_CPV to ETD;
    ```

- `SELECT` sur `ETD_RIBOULET_CPV_GIRONDE`
  
  - ```sql
    grant SELECT on ETD_RIBOULET_CPV_GIRONDE to ETD;
    ```

**21)** Ouverture de session sur `ETD` 

> On est sur `ETD` à partir de maintenant

**22)** Insérer dans la table depuis `ETD`

```sql
insert into ETD_RIBOULET.ETD_RIBOULET_CPV values ('33000', 'Bordeaux');
```

```sql
commit
```

**23)** Afficher toutes les lignes depuis `ETD`

```sql
select * from ETD_RIBOULET.ETD_RIBOULET_CPV;
```

![](./assets/2022-01-05-15-21-41-image.png)

**24)** Récupérer toutes les villes de gironde

```sql
select * from ETD_RIBOULET.ETD_RIBOULET_CPV_GIRONDE;
```

![](./assets/2022-01-05-15-27-30-image.png)

**25)** Retirer les privilèges à un utilisateur

> On est sur `ETD_RIBOULET` a partir de maintenant

```sql
revoke INSERT on ETD_RIBOULET_CPV from ETD;
```

**26)** Essayer en tant que `ETD` d'inserer dans la table

```sql
insert into ETD_RIBOULET.ETD_RIBOULET_CPV values('59000', 'Lille');
```

![loading-ag-392](./assets/2022-01-05-15-36-34-image.png)

## J/ Définition des données : table, contraintes d'intégrités, index

> Sur `ETD_RIBOULET`

**49)** Ajouter contrainte d'intégrité sur la colonne Ville de la table `ETD_RIBOULET_CPV`

```sql
alter table ETD_RIBOULET_CPV modify Ville varchar(30) not null;
```

```sql
alter table ETD_RIBOULET_CPV 
add constraint "EXISTS_RIBOULET_VILLE" check (Ville is not null);
```

```sql
insert into ETD_RIBOULET_CPV values ('12348', NULL);
```

> Erreur

Création de la table `ETD_RIBOULET_DKCLD`

```sql
create table ETD_RIBOULET_DKCLD (
    Id number generated always as identity,
    CPDepart CHAR(5) not null,
    CPArrivee CHAR(5) not null,
    DistKm number(5) not null,
    constraint PK_RIBOULET_DKCLD primary key(Id),
    constraint FK_RIBOULET_CPDepart 
        foreign key (CPDepart) references ETD_RIBOULET_CPV(CodePostal),
    constraint FK_RIBOULET_CPArrivee 
        foreign key (CPArrivee) references ETD_RIBOULET_CPV(CodePostal),
    constraint CI_RIBOULET_CPDepartCPArrivee 
        check (CPDepart < CParrivee),
    constraint CI_RIBOULET_CPDepart000 
        check (CPDepart like '%000'),
    constraint CI_RIBOULET_CPArrivee000 
        check (CPArrivee like '%000'),
    constraint UNIQ_RIBOULET_CodePostaux 
        unique (CPDepart, CPArrivee)
);
```

```sql
create index INDX_RIBOULET_DistKm on ETD_RIBOULET_DKCLD(DistKm);
```

```mermaid
erDiagram
    ETD_RIBOULET_CPV {
        char CodePostal 
        char Ville
    }
    ETD_RIBOULET_DKCLD ||--o| ETD_RIBOULET_CPV : CPDepart
    ETD_RIBOULET_DKCLD ||--o| ETD_RIBOULET_CPV : CPArrive
    ETD_RIBOULET_DKCLD {
        number id
        number DistKm 
    }
```

**50)** Inserer des villes

```sql
insert into ETD_RIBOULET_CPV values ('06000', 'Nice');
insert into ETD_RIBOULET_CPV values ('13000', 'Marseille');
insert into ETD_RIBOULET_CPV values ('69000', 'Lyon');
insert into ETD_RIBOULET_CPV values ('31000', 'Toulouse');
```

**51)** Insérer distance entre les villes
