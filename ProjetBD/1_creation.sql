CREATE TABLE Parfum(
   id_parfum INT,
   nom_parfums VARCHAR(50) NOT NULL,
   annee_creation INT(4) NOT NULL,
   famille_olfactive VARCHAR(50) NOT NULL,
   concentration_parfum INT NOT NULL,
   nez_parfum VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_parfum)
);
 
CREATE TABLE Mode_de_Paiement(
   id_mode_paiement INT,
   libelle_mode_paiement VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_mode_paiement)
);
 
CREATE TABLE Promotion(
   code_promotion VARCHAR(50),
   remise_promotion INT NOT NULL,
   PRIMARY KEY(code_promotion)
);
 
CREATE TABLE Adresse(
   id_adresse VARCHAR(50),
   numero_voie VARCHAR(10) NOT NULL,
   nom_voie VARCHAR(100) NOT NULL,
   code_postal CHAR(5) NOT NULL,
   ville VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_adresse)
);
 
CREATE TABLE Produit(
   reference_produit VARCHAR(50),
   nom_produit VARCHAR(50) NOT NULL,
   type_produit VARCHAR(50) NOT NULL,
   contenance_ml_produit INT NOT NULL,
   prix_produit DECIMAL(10,2) NOT NULL,
   description_produit VARCHAR(255) NOT NULL,
   reference_produit_1 VARCHAR(50),
   PRIMARY KEY(reference_produit),
   FOREIGN KEY(reference_produit_1) REFERENCES Produit(reference_produit)
);
 
CREATE TABLE Note(
   id_note INT,
   nom_note VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_note)
);
 
CREATE TABLE Mode_de_livraison(
   id_mode_livraison INT,
   libelle_mode_livraison VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_mode_livraison)
);
 
CREATE TABLE Client(
   numero_client INT,
   genre_client VARCHAR(50) NOT NULL,
   age_client INT NOT NULL,
   nom_client VARCHAR(50) NOT NULL,
   prenom_client VARCHAR(50) NOT NULL,
   email_client VARCHAR(50) NOT NULL,
   telephone_client CHAR(10) NOT NULL,
   id_adresse VARCHAR(50) NOT NULL,
   PRIMARY KEY(numero_client),
   FOREIGN KEY(id_adresse) REFERENCES Adresse(id_adresse)
);
 
CREATE TABLE Panier(
   Id_panier INT,
   date_creation DATE NOT NULL,
   numero_client INT,
   PRIMARY KEY(Id_panier),
   FOREIGN KEY(numero_client) REFERENCES Client(numero_client)
);
 
CREATE TABLE Commande(
   Num_commande INT,
   statut_commande VARCHAR(50) NOT NULL,
   date_commande DATE NOT NULL,
   frais_livraison DECIMAL(10,2) NOT NULL,
   prix_unitaire_commande DECIMAL(10,2) NOT NULL,
   code_promotion VARCHAR(50),
   id_mode_paiement INT NOT NULL,
   Id_panier INT NOT NULL,
   id_mode_livraison INT NOT NULL,
   id_adresse VARCHAR(50) NOT NULL,
   PRIMARY KEY(Num_commande),
   UNIQUE(Id_panier),
   FOREIGN KEY(code_promotion) REFERENCES Promotion(code_promotion),
   FOREIGN KEY(id_mode_paiement) REFERENCES Mode_de_Paiement(id_mode_paiement),
   FOREIGN KEY(Id_panier) REFERENCES Panier(Id_panier),
   FOREIGN KEY(id_mode_livraison) REFERENCES Mode_de_livraison(id_mode_livraison),
   FOREIGN KEY(id_adresse) REFERENCES Adresse(id_adresse)
);
 
CREATE TABLE Retour(
   Num_commande INT,
   num_retour INT,
   date_retour DATE NOT NULL,
   motif_retour VARCHAR(50) NOT NULL,
   statut_retour VARCHAR(50) NOT NULL,
   PRIMARY KEY(Num_commande, num_retour),
   FOREIGN KEY(Num_commande) REFERENCES Commande(Num_commande)
);
 
CREATE TABLE Contient_panier(
   Id_panier INT,
   reference_produit VARCHAR(50),
   quantite INT NOT NULL,
   PRIMARY KEY(Id_panier, reference_produit),
   FOREIGN KEY(Id_panier) REFERENCES Panier(Id_panier),
   FOREIGN KEY(reference_produit) REFERENCES Produit(reference_produit)
);
 
CREATE TABLE possede(
   id_parfum INT,
   id_note INT,
   PRIMARY KEY(id_parfum, id_note),
   FOREIGN KEY(id_parfum) REFERENCES Parfum(id_parfum),
   FOREIGN KEY(id_note) REFERENCES Note(id_note)
);
 
CREATE TABLE Correspond(
   id_parfum INT,
   reference_produit VARCHAR(50),
   stock_produit INT NOT NULL,
   quantite_parfums INT NOT NULL,
   PRIMARY KEY(id_parfum, reference_produit),
   FOREIGN KEY(id_parfum) REFERENCES Parfum(id_parfum),
   FOREIGN KEY(reference_produit) REFERENCES Produit(reference_produit)
);
 
CREATE TABLE Retourne(
   reference_produit VARCHAR(50),
   Num_commande INT,
   num_retour INT,
   quantite_retourne INT NOT NULL,
   PRIMARY KEY(reference_produit, Num_commande, num_retour),
   FOREIGN KEY(reference_produit) REFERENCES Produit(reference_produit),
   FOREIGN KEY(Num_commande, num_retour) REFERENCES Retour(Num_commande, num_retour)
);
