/*
-- =========================================================================== A
Produit : CoFELI.Exemple.Universite
Variante : 2023.iter04
Artefact : Universite_IMM_base.sql
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 0.4.0.b (2021-03-21)
Statut : travail en cours
Encodage : UTF-8, sans BOM; fin de ligne simple (LF)
Plateformes : PostgreSQL 12+
-- =========================================================================== A
*/

/*
-- =========================================================================== B

=== Itération 04

Définir l’interface machine-machine (IMM) de la base de données Universite, interface
correspondant aux fonctionnalités de base recherchées suivantes :

  * Ajouter, retirer, modifier : un professeur, un étudiant, un cours, une offre un groupe.
  * Ajouter, retirer : une compétence, une disponibilité ou une affectation à un professeur.
  * Ajouter, retirer : une inscription d’un étudiant à un groupe.
  * Ajouter, retirer : un préalable à un cours.
  * Attribuer, modifier : la note d’un étudiant en regard d’une inscription à un groupe.
  * Déterminer si un étudiant remplit les conditions préalables à un cours.
  * Déterminer si l’offre effective d’un trimestre est en accord avec l’offre planifiée.

L’IMM est aussi appelée souvent appelée interface programmatique ou, en anglais,
application programming interface (API).

-- =========================================================================== B
*/

--
--  Ouvrir la portée de l’interface précédemment créée.
--
set search_path to 'IMM_base', 'MDD';

--
--  Professeur
--  L’interface de gestion des professeurs.
--

-- Cette procédure stockée ajoute une note d'évaluation à un étudiant par sur un cours precis
create or replace procedure addEvaluation( matricules "MDD".matriculee, sigles "MDD".sigle, mark "MDD".note,
                                           groupe "MDD".nogroupe, trimester "MDD".trimestre
)
    external security definer
begin
    atomic
    insert into "MDD".evaluation (matriculee, sigle, trimestre, nogroupe, note)
    values (matricules, sigles, trimester, groupe, mark);
end;


-- Fonction qui liste les étudiants qui participent à un cours spécifique
create or replace function listeEtudiantsCours(sigleCours "MDD".sigle, matriculeProfesseur "MDD".matriculep)
    returns table
            (
                matriculee "MDD".matriculee,
                nom        "MDD".nom
            )
    language plpgsql
    external security definer
as $$
BEGIN 
    atomic
    select e.matriculee, e.nom
    from "MDD".etudiant e
             inner join "MDD".inscription i on e.matriculee = i.matriculee
             inner join "MDD".affectation a on i.sigle = a.sigle
    where a.matriculep = matriculeProfesseur
      and i.sigle = sigleCours;
END;
$$;


-- Fonction qui indique si un professeur a un bureau
CREATE OR REPLACE FUNCTION verifierBureauProfesseur(matriculeProfesseur "MDD".matriculep)
    RETURNS VARCHAR(255)
    LANGUAGE PLPGSQL
    SECURITY DEFINER
AS
$$
DECLARE
    resultat VARCHAR(255);
BEGIN
    IF EXISTS (
        SELECT 1 FROM "MDD".professeur_bureau_pre
        WHERE matriculep = matriculeProfesseur
    ) THEN
        resultat := 'Vous avez un bureau.';
    ELSE
        SELECT cause
        INTO resultat
        FROM "MDD".professeur_bureau_abs
        WHERE matriculep = matriculeProfesseur;

        resultat := 'Vous n''avez pas de bureau. Cause : ' || resultat;
    END IF;
    RETURN resultat;
END
$$;

/*
-- =========================================================================== Z

=== Contributeurs
  (CK01) Christina.Khnaisser@USherbrooke.ca,
  (LL01) Luc.Lavoie@USherbrooke.ca

=== Adresse, droits d’auteur et copyright
  Groupe Μῆτις (Métis)
  Département d’informatique
  Faculté des sciences
  Université de Sherbrooke
  Sherbrooke (Québec)  J1K 2R1
  Canada
  http://info.usherbrooke.ca/llavoie/
  [CC-BY-NC-4.0 (http://creativecommons.org/licenses/by-nc/4.0)]

=== Tâches projetées
  TODO 2021-03-19 (LL01) : Mettre en oeuvre l’IMM.

=== Tâches réalisées
  2021-03-19 (LL01) : Inventaire des composantes de l'IMM de base
    - Inventaire découlant de l’ébauche proposée à l’étape 03.

=== Références
[ddv] http://info.usherbrooke.ca/llavoie/enseignement/Exemples/Universite/
      Universite_DDV.pdf
[std] http://info.usherbrooke.ca/llavoie/enseignement/Modules/
      BD190-STD-SQL-01_NDC.pdf

-- =========================================================================== Z
*/
