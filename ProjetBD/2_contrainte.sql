ALTER TABLE Client
ADD CONSTRAINT uq_client_email UNIQUE (email_client);
 
ALTER TABLE Client
ADD CONSTRAINT ck_client_email
CHECK (email_client REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$');
 
ALTER TABLE Client
ADD CONSTRAINT ck_client_telephone
CHECK (telephone_client REGEXP '^0[1-9][0-9]{8}$'),
 
ALTER TABLE Client
ADD CONSTRAINT age_client 
CHECK (age_client > 18);

ALTER TABLE Client
ADD CONSTRAINT genre_client
CHECK (genre_client IN ('homme', 'femme', 'autre'));
 
ALTER TABLE Adresse
ADD CONSTRAINT ck_adresse_code_postal
CHECK (code_postal REGEXP '^[0-9]{5}$');

ALTER TABLE Adresse
ADD CONSTRAINT ville_composee
CHECK (ville NOT LIKE '% %'); 

ALTER TABLE Mode_de_Paiement
ADD CONSTRAINT ck_paiement_libelle
CHECK (libelle_mode_paiement IN ('paypal', 'mastercard', 'visa', 'alipay'));
 
ALTER TABLE Commande
ADD CONSTRAINT ck_commande_statut
CHECK (statut_commande IN ('en attente', 'en cours', 'livré'));
 
ALTER TABLE Retour
ADD CONSTRAINT ck_retour_statut
CHECK (statut_retour IN ('en attente', 'en cours', 'retourné'));

ALTER TABLE Produit
ADD CONSTRAINT ck_produit_prix CHECK (prix_produit > 0);
 
ALTER TABLE Correspond
ADD CONSTRAINT ck_produit_stock CHECK (stock_produit >= 0);
 
ALTER TABLE Produit
ADD CONSTRAINT ck_produit_contenance CHECK (contenance_ml_produit > 0);
 
ALTER TABLE Parfum
ADD CONSTRAINT ck_parfum_concentration
CHECK (concentration_parfum BETWEEN 1 AND 100);
 
ALTER TABLE Promotion
ADD CONSTRAINT ck_promotion_remise
CHECK (remise_promotion BETWEEN 1 AND 100);
 
ALTER TABLE Commande
ADD CONSTRAINT ck_commande_frais CHECK (frais_livraison >= 0);
 
ALTER TABLE Commande
ADD CONSTRAINT ck_commande_prix_unitaire CHECK (prix_unitaire_commande >= 0);
 
ALTER TABLE Contient_panier
ADD CONSTRAINT ck_contient_quantite CHECK (quantite > 0);
 
ALTER TABLE Correspond
ADD CONSTRAINT ck_correspond_quantite CHECK (quantite_parfums > 0);
 
ALTER TABLE Retourne
ADD CONSTRAINT ck_retourne_quantite CHECK (quantite_retourne > 0);
 
ALTER TABLE Produit
ADD CONSTRAINT ck_produit_pas_auto_recharge
CHECK (reference_produit_1 <> reference_produit);
