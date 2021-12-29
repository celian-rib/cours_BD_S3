# TD1 BD Avancées

**Q 10**

| P   | Clé primaire          |
| --- | --------------------- |
| U   | Unicité               |
| R   | Référentiel           |
| C   | Check (tout le reste) |

**Q 10**

```sql
select TABLE_NAME , CONSTRAINT_NAME 
from ALL_CONSTRAINTS 
where OWNER = 'ADMIN'
and TABLE_NAME in ( 'PLACE' , 'SEANCE' , 'RESERVATION' ) 
and CONSTRAINT_TYPE = 'P' 
order by TABLE_NAME , CONSTRAINT_NAME ; 
```

__clés  primaires__ :

P [n° place] est la clé de P => PK_PLACE

S [n° séance] est la clé de S => PK_SEANCE

R [n° place, n° séance] est la clé de R => PK_RESERVATION

__contraintes d'intégrité référentielles__

Résumé résultat requêtes :

FK1_PLACE :<u> P.[ ] référence (?)</u> => PK_CATE_PLACE

FK1_SCEANCE :<u> S.[ ] référence (?)</u> => PK_FILM

FK2_SCEANCE : <u>S.[ ] référence (?)</u> => PK_PLACE

FK1_RESERVATION : <u>R.[ n°séance ] référence S.n°S</u> => PK_SEANCE

FK2_RESERVATION :<u> R.[ ] référence P.n°P</u> => PK_PLACE

**PK: Primary Key**

**FK: Foreign Key**

**Q18**

Une vue est une table virtuelle qui n'existe pas vraiment.

Il en existe 4

ALL_CONSTRAINTS

ALL_CONS_COLUMNS

ALL_INDEXES

ALL_IND_COLUMNS

Il ny a aucune différence entre une vue et une table en terme d'utilisation

(```select * from <table/vue>```)

**Q19**

```sql
select seance.numero_seance, reservation.numero_place, reservation.nom_spectateur from seance
inner join reservation on reservation.numero_seance = seance.numero_seance
inner join place on place.numero_place = reservation.numero_place
where place.categorie_de_la_place = 'A'
```

**Q20**

```sql
select VIEW_NAME from ALL_VIEWS where OWNER = 'ADMIN'
```

Afficher le nom de la vue depuis la vue ALL_VIEWS qui contient toutes les vues dont le propriètaire est ADMIN

(La définition d'une VUE est récursive)

**Q21**

Pour connaitre le type d'un attribut dans une vue, on utilise describe

```sql
DESCRIBE ALL_VIEWS
```

**Q22**

```sql
select TEXT
from ALL_VIEWS
where OWNER = 'ADMIN' and VIEW_NAME = 'RESERVATION_CATEGORIE_A';
```

Output :

```
"select NUMERO_SEANCE , NUMERO_PLACE , NOM_SPECTATEUR
    from RESERVATION 
    natural join PLACE -- c.-à-d. join PLACE on RESERVATION.NUMERO_PLACE = PLACE.NUMERO_PLACE
    where CATEGORIE_DE_LA_PLACE = 'A'"
```

**Q23**

```sql
select * from RESERVATION_CATEGORIE_A
```

**Q24**

```sql

```

**Q32**

La clé primairede la relation est le couple numéro séance, numéro place

**Q33**

a) 

```sql
select * from reservation
```

b)

```sql
insert into reservation values (9, 10, 'OuiOui')
```

c)
Non elle n'apparaît pas dans les autres sessions

```sql
select * from reservation where numero_seance = 9
```

d)

```sql
commit
```

e) La ligne est visible sur toutes les sessions

```sql
select * from reservation where numero_seance = 9
```

f)

```sql
insert into reservation values (9, 10, 'NonNon')
```

g)

```sql
select * from reservation where numero_seance = 9
```

h)

```sql
rollback
```

i)

```sql
select * from reservation where numero_seance = 9
```

**34**

a)

```sql
insert into reservation values (9, 15, 'Hello')
```

b) La transaction n'est pas visible sur l'autre session

c) La transaction reste en attente

e) Après le rollback, l'insert de la première session est annulé et celui qui était en attente est validé.
On voit donc l'insert que dans la seconde session et plus dans la première

f) Après commit dans la première session, l'ajout est visible depuis toutes les sessions

**35**

a)

```sql
insert into reservation values (9, 100, 'Bonsoir')
```

b)

```sql
select * from reservation where numero_seance = 9
```

**38**

```sql
select s.sid, s.lockwait, s.blocking_session, s.final_blocking_session from v$session s  left outer join v$transaction t on s.taddr = t.addr
```

**40**

<u>Assertion</u> : Contrainte d'intégrité qui contient au moins des informations  de 2 tables. Formule logique qui doit être vraie.

<u>Base de données </u>: Ensemble d'informations structurées

<u>Clé étrangère : </u>Clé qui référence la clé primaire d'une autre table

<u>Clé primaire :</u> Attribut unique pour tous les éléments d'une table

<u>Cluster :</u> Collection de base de données gérées par un seul SGBD

<u>Colonne </u>: Attribut d'une table correspondant à une catégorie d'information

<u>Contrainte d'intégrité </u>: régle qui définir la cohérence d'une données ou d'un ensemble de données de la bd

<u>Curseur : </u>Pointeur vers une donnée pour effectuer un calcul

<u>Déclencheur :</u> Déclenche l'execution d'une instruction

<u>Espace de tables :</u> Espace de stockage qui contient les informations et données à propos des composant d'une base de données

<u>Exception : </u>Erreur dans une action effectuée sur la base de données

<u>Fichier : </u>

<u>Fonction stockés : </u>

<u>Index :</u> Structure de données entretenue par le SGBD pour lui permettre de retrouver rapidement ses données.

<u>Journal :</u> Endroit de stockage de l'ensemble des transation finis ou encore en cours

<u>Paquetage :</u> Ensemble de méthodes et fonctions qui sont cohérentes (Namespace / Petite biblitohèque)

<u>Photographie :</u> Copie d'une table (Prblm : perte d'espace disque et rique d'incohérence)

<u>Privilège :</u> Autorisation donnée à un utilisateur de la BD 

(Deux types : Objets (update, insert, delete, select, exec)/ Système (creer user / suppr table / droit généraux sur la dba))

<u>Procédure (stockées) :</u> Série d'instructions SQL

<u>Processus :</u> Programme en cours d'éxécution

<u>Rôle : </u> Ensemble de droit et de role (Définition récursive / Composant composite)

<u>Schéma de BD :</u> 

<u>Session :</u> Connexion unique maintenue avec la base de données

<u>Séquence :</u> suite de nombres (Utilisé pour les numéro automatiques)

<u>Synonyme :</u> Nom alternatif pour une table ADMIN.matable => "matable".

<u>Table :</u> Ensemble de données du même type.

<u>Transaction :</u> Ensemble de requêtes de mise à jour.

<u>Utilisateur :</u> Quelqu'un qui a des droits (Compte).

<u>Vue :</u> une synthèse d'une requête d'interrogation de la base (Table virtuelle, définir par une requête)

**41**

a)

```sql
insert into reservation values (10,100, 'criboulet')
```

```sql
select * from reservation where numero_place = 100
```

```sql
execute INSER_1_RESA_OBLIG(10, 100);
```

INSER_1_RESA_OBLIG ne change rien

c'est une procèdure

```sql
delete from reservation where numero_place = 100 and numero_seance = 10
```

```sql
execute INSER_1_RESA_OBLIG(10, 100);
```

INSER_1_RESA_OBLIG fonctionne que la ligne existe ou non dans la DB

b)

```sql
select * from reservation where numero_seance = 1 and numero_place = 64
```

```sql
select * from reservation where numero_seance = 1 and numero_place = 64
```

```sql
execute INSER_1_RESA_OBLIG(1, 64);
```

<u>Erreur</u> 

> cette reservation est obligatoire : vous ne pouvez pas la supprimer

```sql
delete from reservation where numero_place = 1 and numero_seance = 64
```

>  cette reservation est obligatoire : vous ne pouvez pas la supprimer

Le type d'objet implicitement manipulé par le delete est une procédure, en peut le déduire avec le message d'erreur suivant durant la delete

Il y a aussi un déclencheur qui lance la procédure durant le delete

```
BEGIN INSER_1_RESA_OBLIG(1, 64); END;
Rapport d'erreur -
ORA-20000: cette reservation est obligatoire : vous ne pouvez pas la supprimer
ORA-06512: à "ADMIN.INSER_1_RESA_OBLIG", ligne 48
ORA-06512: à ligne 1
20000. 00000 -  "%s"
*Cause:    The stored procedure 'raise_application_error'
           was called which causes this error to be generated.
*Action:   Correct the problem as described in the error message or contact
           the application administrator or DBA for more information.

0 lignes supprimé.
```

La réservation na donc pas été supprimée

<u>Algo déclencheur</u>

```
Before
delete reservation
|execute INSER_1_RESA_OBLIG(old:numero_place,old:numero_seance)
```

> Le déclencheur appel la procédure des qu'il y a un delete sur la table réservation

<u>Algo procédure</u>

```
Si reservation existe
|Stoper -> Erreur
Sinon
|Rien
```

**43 Mise en suspens des contraintes d'intégrité**

**DEFERRABLE** : contrainte que l'on peut marquer comme `INITIALY IMMEDIATE` ou `INITIALLY DEFFERED` 

**IMMEDIATE** : La contrainte est vérifiée directement 

**DEFERRED** : La contrainte est vérifié plus tard => au moment du commit

**ENABLE** : contrainte activée

**DISABLE** : contrainte désactivée

> Peut être utile si on a un traitement qui prend baucoup de temps par exemple.

**VALIDATE :** On ajoute une contrainte d'intégrité à une BD existante => On vérifie toutes les anciennes valeurs et ls nouvelles.

**NO VALIDATE :** On ajoute une contrainte d'intégrité à une BD existante => On vérifie les nouvelles valeurs et tant pis pour les anciennes valeurs.

**44**

- On intérrogae l'horraire de la séance 1

- On veut mettre 99 mais il y a une violation de contrainte (Heure entre 1 et 24)

- On désactive la contrainte

- On met 99 dans les heures

- On réactive la contrainte => ca ne marche pas car il y a des données qui ne vérifient pas la contrainte

- On remet l'horaire à 14

- On réactive la contrainte

**45**

- On met Alix en 1 1 dans reservations

- On ajoute un attribut à la table reservation

- On enléve tout de suite l'attribut de la table réservation (Ce qui devrait être neutre)

- On fais un rollback

- Alix na pas été supprimée