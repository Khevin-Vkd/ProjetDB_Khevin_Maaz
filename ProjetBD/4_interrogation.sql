/* Chiffre d'affaire realise */
SELECT 
SUM(COALESCE(c.prix_unitaire_commande - c.prix_unitaire_commande * p.remise_promotion / 100, c.prix_unitaire_commande)) AS "Chiffre d'Affaires"
FROM Commande c
LEFT JOIN Promotion p ON p.code_promotion = c.code_promotion ;

/* Chiffre d'affaire realise par statut de livraison */
SELECT 
c.statut_commande AS Statut,
SUM(COALESCE(c.prix_unitaire_commande - c.prix_unitaire_commande * p.remise_promotion / 100, c.prix_unitaire_commande)) AS "Chiffre d'Affaires"
FROM Commande c
LEFT JOIN Promotion p ON p.code_promotion = c.code_promotion
GROUP BY c.statut_commande;

/* Les commandes entre 100 et 200 euros */
SELECT Num_commande, prix_unitaire_commande
FROM Commande
WHERE prix_unitaire_commande BETWEEN 100 AND 200
ORDER BY prix_unitaire_commande ASC;

/* Classement de tous les produits vendus par Quantite Vendues */
SELECT pr.nom_produit AS Produit, SUM(cp.quantite) AS Quantités_vendues, SUM(co.prix_unitaire_commande) AS CA
FROM Parfum p
JOIN Correspond c ON c.id_parfum = p.id_parfum
JOIN Produit pr ON c.reference_produit = pr.reference_produit
JOIN Contient_panier cp ON cp.reference_produit = c.reference_produit
JOIN Commande co ON co.Id_panier = cp.Id_panier
GROUP BY pr.reference_produit, pr.nom_produit
ORDER BY Quantités_vendues DESC;

/* Produits vendus dont le parfum est Soie Malaquais par ordre alphabetique */
SELECT pr.nom_produit AS Produit, SUM(cp.quantite) AS Quantités_vendues, SUM(co.prix_unitaire_commande) AS CA
FROM Parfum p
JOIN Correspond c ON c.id_parfum = p.id_parfum
JOIN Produit pr ON pr.reference_produit = c.reference_produit
JOIN Contient_panier cp ON cp.reference_produit = pr.reference_produit
JOIN Commande co ON co.Id_panier = cp.Id_panier
WHERE (p.nom_parfums = "Soie Malaquais")
GROUP BY pr.reference_produit, pr.nom_produit
ORDER BY pr.nom_produit ASC;

/* Clients dont le nom commence par M */
SELECT 
numero_client,
nom_client,
prenom_client
FROM Client
WHERE nom_client LIKE "M%" ;

/* Clients par genre */
SELECT
SUM(genre_client = "homme") AS Hommes,
SUM(genre_client = "femme") AS Femmes,
SUM(genre_client = "autre") AS Autres
FROM Client ; 

/* Clients triés par âge décroissant puis par nom */
SELECT nom_client, prenom_client, age_client
FROM Client
ORDER BY age_client DESC, nom_client ASC;

/* Les types de produits achetés par tranche d’age définies */
SELECT
pr.type_produit,
COUNT(DISTINCT CASE WHEN age_client BETWEEN 18 AND 25 THEN c.numero_client END) AS "18-25",
COUNT(DISTINCT CASE WHEN age_client BETWEEN 26 AND 36 THEN c.numero_client END) AS "26-36",
COUNT(DISTINCT CASE WHEN age_client BETWEEN 37 AND 45 THEN c.numero_client END) AS "37-45",
COUNT(DISTINCT CASE WHEN age_client > 45 THEN c.numero_client END) AS "46+"
FROM Client c
/* Je veux lier ma table Client a la table Produit donc il faut faire tout le chemin jusque la */
JOIN Panier pan ON pan.numero_client = c.numero_client
JOIN Contient_panier cp ON cp.id_panier = pan.id_panier
JOIN Produit pr ON pr.reference_produit = cp.reference_produit
GROUP BY pr.type_produit
ORDER BY type_produit ASC;

/* Les villes existantes dans la base de donnees */
SELECT DISTINCT ville
FROM Adresse
ORDER BY ville ;

/* Classement des villes par quantites vendues */
SELECT 
a.ville AS Ville, 
SUM(cp.quantite) AS Quantites_vendues
FROM Adresse a
JOIN Commande c ON c.id_adresse = a.id_adresse
JOIN Contient_panier cp ON cp.id_panier = c.id_panier
GROUP BY a.ville
ORDER BY Quantites_vendues DESC;

/* Les clients qui ont le meme age (tous les clients ont des noms et prenoms differents) */
SELECT age_client, COUNT(*) AS nombre
FROM Client
GROUP BY age_client
HAVING COUNT(*) > 1 ;

/* Les clients qui au moins deux commandes */
SELECT 
c.numero_client,
c.nom_client,
c.prenom_client,
COUNT(co.Num_commande) AS "Nombre commandes"
FROM Client c 
JOIN Panier p ON p.numero_client = c.numero_client
JOIN Commande co ON co.id_panier = p.id_panier
GROUP BY c.numero_client, c.nom_client, c.prenom_client
HAVING COUNT(*) > 1 ;

/* Clients qui ont constitue un panier */
SELECT nom_client, prenom_client
FROM Client
WHERE numero_client NOT IN (
    SELECT numero_client
    FROM Panier
);

/* Les produits dans un panier */
SELECT nom_produit, type_produit
FROM Produit
WHERE reference_produit IN (
    SELECT reference_produit
    FROM Contient_panier
);

/* Les clients avec une commande livree */
SELECT nom_client, prenom_client
FROM Client c
WHERE EXISTS (
    SELECT 1
    FROM Panier p
    JOIN Commande co ON co.id_panier = p.id_panier
    WHERE p.numero_client = c.numero_client AND co.statut_commande = "livré"
);

/* Statut des livraisons */
SELECT
SUM(statut_commande = "livré") AS Livré,
SUM(statut_commande = "en cours") AS "En cours",
SUM(statut_commande = "en attente") AS "En attente"
FROM Commande;

/* Statuts des retours */
SELECT
r1.num_commande AS "ID Commande",
r2.reference_produit AS "Produit", 
r2.quantite_retourne AS "Quantite",
r1.motif_retour AS Motif, 
r1.date_retour AS "Date de retour", 
r1.statut_retour AS Statut
FROM Retour r1
LEFT JOIN Retourne r2 ON r1.Num_commande = r2.Num_commande AND r2.num_retour = r1.num_retour;

SELECT
COUNT(DISTINCT r1.Num_commande, r1.num_retour) AS "Nombre de retours",
COUNT(r2.reference_produit) AS "Produits retournés",
SUM(r2.quantite_retourne) AS "Unités retournées"
FROM Retour r1
LEFT JOIN Retourne r2 ON r2.Num_commande = r1.Num_commande AND r2.num_retour = r1.num_retour;

/* Eventuelles reductions appliques aux commandes */
SELECT 
c.num_commande AS "Numero commande",
c.prix_unitaire_commande AS "CA Hors Reductions",
/* Retourme 0 s'il n'y a pas de reduction */ 
COALESCE(p.remise_promotion, 0) AS "Remise %",
/* Calcule le chiffre realise avec reduction et retourne le chiffre realise si il n'y a pas de reductions */ 
COALESCE(c.prix_unitaire_commande - c.prix_unitaire_commande * p.remise_promotion / 100, c.prix_unitaire_commande) AS "CA avec Reductions"
FROM Commande c
LEFT JOIN Promotion p ON p.code_promotion = c.code_promotion;

/* Les notes des parfums */
SELECT 
p.nom_parfums AS Parfum,
/* Au lieu d'ecrire les notes unes par unes, les assemble en une seule case */
GROUP_CONCAT(n.nom_note ORDER BY n.nom_note SEPARATOR ', ') AS Notes
FROM Parfum p
JOIN possede psd ON psd.id_parfum = p.id_parfum
JOIN Note n ON n.id_note = psd.id_note 
GROUP BY p.id_parfum, p.nom_parfums ;

/* Les parfums qui ne contiennent pas de vanille */
SELECT 
p.nom_parfums AS Parfum
FROM Parfum p
WHERE NOT EXISTS (
SELECT 1
FROM possede psd
JOIN Note n ON n.id_note = psd.id_note
WHERE psd.id_parfum = p.id_parfum AND n.nom_note = "Vanille"
)
ORDER BY p.nom_parfums;

/* La liste des parfums */
SELECT DISTINCT nom_parfums FROM Parfum
ORDER BY nom_parfums;

/* Les produits qui sont soit des flacons soit des recharges */
SELECT 
reference_produit,
nom_produit 
type_produit
FROM Produit
WHERE type_produit IN ('flacon', 'recharge')
ORDER BY reference_produit ;

/* Produits plus chers que tous les produits de type 'Set' */
SELECT nom_produit, prix_produit
FROM Produit
WHERE prix_produit > ALL (
    SELECT prix_produit
    FROM Produit
    WHERE type_produit = "Set"
);
