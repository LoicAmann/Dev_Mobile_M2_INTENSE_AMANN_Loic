# miaged

## Résumé

Il s'agit d'un projet universitaire individuelle. Il se pose dans le cadre du cours Développement mobile du M2 MIAGE INTENSE (promo 2024).

Voici ce que couvre ce projet par rapport aux consignes données :
- US#1 : [MVP] Interface de login : **Fonctionnel**
- US#2 : [MVP] Liste des activités : **Fonctionnel**
- US#3 : [MVP] Détail d’une activité : **Fonctionnel**
- US#4 : [MVP] Le panier : **Fonctionnel**
- US#5 : [MVP] Profil utilisateur : **Fonctionnel**
- US#6 : Page d'inscription : **Fonctionnel**

Le projet couvre donc tout le _MVP_ + une page d'inscription. 

La base de données est hébergée avec FireBase et une _database_ _Firestore_. Cette bdd contient 3 collections : `Activities`, `Panier` et `Users`.

## Comment lancer le projet ?

Pour cela vous pouvez suivre ce tuto (que j'ai utilisé pour initialiser le projet), qui aidera mieux que mes explications.

Mon environnement est sur _Visual Studio Code_, avec la version 3.16.8 de _flutter_.

Ensuite, grâce à _VSCode_, vous pouvez run l'application. Si vous voulez le faire via un émulateur de téléphone, vous pouvez installer android studio. Sinon, vous pouvez utiliser votre navigateur (j'ai utilisé _Chrome_) et afficher sous le format smartphone.

## Précisions sur le code

Il faut savoir que l'architecture peut paraitre étrange et non conforme aux principes de _clean code_. En effet, lorsque j'ai commencé, j'ai voulu mettre en place un _MVC_ (d'où certaines fonctionnalités avec un MVC comme le login ou la home page, avec des modèles de `user` et `activity`). Cependant, je me suis rendu compte que pour un petit projet d'initiation à _flutter_, une telle architecture était inutile (d'autant plus que je ne maitrise pas le langage). De plus, dans le main, j'ai une classe `GLOBAL` qui aurait pu suffir à stocker les données comme le _login/password_ du _user_ qui se connecte, toutes les activités, etc. 

Aucun design spécial n'a été fait. L'application reste simple.

# Enoncé

## Objectifs

L’objectif de ce second TP consiste à développer une application qui propose des activités à réaliser en
groupe.
Dans le fonctionnement actuel des entreprises, celle-ci définissent le plus souvent, dans le cadre du
développement d’une application, une version MVP (Minimum viable product ➔ Produit minimum viable).
Le MVP est la version d’un produit qui permet d’obtenir un maximum de retours client avec un minimum
d’effort. Nous allons donc appliquer ce système est définir un MVP.
En parallèle, énormément d’entreprises passent aux méthodologies agiles et la rédaction de User Story.
Nous allons donc appliquer ce formalisme pour exprimer les différents besoins. Chaque User Story
composant le MVP sera préfixé de [MVP] dans son titre.
