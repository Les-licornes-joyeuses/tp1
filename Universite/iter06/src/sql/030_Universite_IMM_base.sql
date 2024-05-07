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
--  Ajouter, retirer, modifier : un professeur, un étudiant, un cours, une offre, un groupe.
--

--  Professeur
--  TODO 2021-03-19 (LL01) : Ajouter, retirer, modifier un professeur
create or replace procedure addProfesseur(matricule "MDD".matriculep, nom "MDD".nom)
    external security definer
begin
    atomic
    insert into "MDD".professeur (matriculep, nom) values (matricule, nom);
end;

create or replace procedure retirerProfesseur(matricule "MDD".matriculep)
    external security definer
begin
    atomic
    delete from "MDD".professeur where matriculep = matricule;

    create or replace procedure modifierProfesseur(matricule "MDD".matriculep, nom "MDD".nom)
        external security definer
    begin
        atomic
        update "MDD".professeur set nom = nom where matriculep = matricule;


--  Étudiant


        --  TODO 2021-03-19 (LL01) : Ajouter, retirer, modifier un étudiant
        create or replace procedure addEtudiant(matricule "MDD".matriculee, nom "MDD".nom, ddn date)
            external security definer
        begin
            atomic
            insert into "MDD".etudiant (matriculee, nom, ddn) values (matricule, nom, ddn);
        end;

        create or replace procedure retirerEtudiant(matricule "MDD".matriculee)
            external security definer
        begin
            atomic
            delete from "MDD".etudiant where matriculee = matricule;
        end;

        create or replace procedure modifierEtudiant(matricule "MDD".matriculee, nom "MDD".nom, ddn date)
            external security definer
        begin
            atomic
            update "MDD".etudiant set nom = nom, ddn = ddn where matriculee = matricule;
        end;

        --  Cours
--  TODO 2021-03-19 (LL01) : Ajouter, retirer, modifier un cours

        create or replace procedure addCours(sigle "MDD".sigle, titre "MDD".titre, credit "MDD".cdc)
            external security definer
        begin
            atomic
            insert into "MDD".cours (sigle, titre, credit) values (sigle, titre, credit);
        end;

        create or replace procedure retirerCours(_sigle "MDD".sigle)
            external security definer
        begin
            atomic
            delete from "MDD".cours where "MDD".cours.sigle = _sigle;
        end;

        create or replace procedure modifierCours(_sigle "MDD".sigle, _titre "MDD".titre, _credit "MDD".cdc)
            external security definer
        begin
            atomic
            update "MDD".cours set titre = _titre, credit = _credit where sigle = _sigle;
        end;

        --  Offre
--  TODO 2021-03-19 (LL01) : Ajouter, retirer, modifier une offre

        create or replace procedure ajouterOffre(_sigle "MDD".sigle, _trimestre "MDD".trimestre)
            external security definer
        begin
            atomic
            insert into "MDD".offre (sigle, trimestre) values (_sigle, _trimestre);
        end;

        create or replace procedure retirerOffre(_sigle "MDD".sigle)
            external security definer
        begin
            atomic
            delete from "MDD".offre where sigle = _sigle;
        end;

        create or replace procedure modifierOffre(_sigle "MDD".sigle, _trimestre "MDD".trimestre)
            external security definer
        begin
            atomic
            update "MDD".offre set trimestre = _trimestre where sigle = _sigle;
        end;

        --  Groupe
--  TODO 2021-03-19 (LL01) : Ajouter, retirer, modifier un groupe

        create or replace procedure ajouterGroupe(_sigle "MDD".sigle, _trimestre "MDD".trimestre,
                                                  _nogroupe "MDD".nogroupe)
            external security definer
        begin
            atomic
            insert into "MDD".groupe (sigle, trimestre, nogroupe) values (_sigle, _trimestre, _nogroupe);
        end;

        create or replace procedure retirerGroupe(_sigle "MDD".sigle)
            external security definer
        begin
            atomic
            delete from "MDD".groupe where sigle = _sigle;
        end;

        create or replace procedure modifierGroupe(_sigle "MDD".sigle, _trimestre "MDD".trimestre,
                                                   _nogroupe "MDD".nogroupe)
            external security definer
        begin
            atomic
            update "MDD".groupe set nogroupe = _nogroupe where sigle = _sigle and trimestre = _trimestre;
        end;
        --
--  Ajouter, retirer : une compétence, une disponibilité ou une affectation à un professeur.
--
        --affectation
        create or replace procedure ajouterAffectation(_sigle "MDD".sigle, _trimestre "MDD".trimestre,
                                                       _nogroupe "MDD".nogroupe, _matriculep "MDD".matriculep)
            external security definer
        begin
            atomic
            insert into "MDD".affectation (sigle, trimestre, nogroupe, matriculep)
            values (_sigle, _trimestre, _nogroupe, _matriculep);
        end;

        create or replace procedure retirerAffectation(_sigle "MDD".sigle, _matriculep "MDD".matriculep)
            external security definer
        begin
            atomic
            delete from "MDD".affectation where sigle = _sigle and matriculep = _matriculep;
        end;

        --competence

        create or replace procedure ajouterCompetence(_sigle "MDD".sigle, _matriculep "MDD".matriculep)
            external security definer
        begin
            atomic
            insert into "MDD".competence (sigle, matriculep) values (_sigle, _matriculep);
        end;

        create or replace procedure retirerCompetence(_sigle "MDD".sigle, _matriculep "MDD".matriculep)
            external security definer
        begin
            atomic
            delete from "MDD".competence where sigle = _sigle and matriculep = _matriculep;
        end;

        --disponibilite

        create or replace procedure ajouterDisponibilite(_trimestre "MDD".trimestre, _matriculep "MDD".matriculep)
            external security definer
        begin
            atomic
            insert into "MDD".disponibilite (trimestre, matriculep) values (_trimestre, _matriculep);
        end;

        create or replace procedure retirerDisponibilite(_trimestre "MDD".trimestre, _matriculep "MDD".matriculep)
            external security definer
        begin
            atomic
            delete from "MDD".disponibilite where trimestre = _trimestre and matriculep = _matriculep;
        end;


        --  TODO 2021-03-19 (LL01) : Ajouter, retirer : une compétence, une disponibilité ou une affectation à un professeur.

--
--  Ajouter, retirer : une inscription d’un étudiant à un groupe.
--
--  TODO 2021-03-19 (LL01) : Ajouter, retirer : une inscription d’un étudiant à un groupe.

        create or replace procedure ajouterInscriptionEtudiantGroupe(_matriculee "MDD".matriculee, _sigle "MDD".sigle,
                                                                     _trimestre "MDD".trimestre,
                                                                     _nogroupe "MDD".nogroupe)
            external security definer
        begin
            atomic
            insert into "MDD".inscription (matriculee, sigle, trimestre, nogroupe)
            values (_matriculee, _sigle, _trimestre, _nogroupe);
        end;

        create or replace procedure retirerInscriptionEtudiantGroupe(_matriculee "MDD".matriculee, _sigle "MDD".sigle,
                                                                     _trimestre "MDD".trimestre,
                                                                     _nogroupe "MDD".nogroupe)
            external security definer
        begin
            atomic
            delete
            from "MDD".inscription
            where matriculee = _matriculee
              and sigle = _sigle
              and trimestre = _trimestre
              and nogroupe = _nogroupe;
        end;
        --  Ajouter, retirer : un préalable à un cours.
--
--  TODO 2021-03-19 (LL01) : Ajouter, retirer : un préalable à un cours.

        --
        create or replace procedure ajouterPrealable(_sigle "MDD".sigle, _sigleprealable "MDD".sigle)
            external security definer
        begin
            atomic
            insert into "MDD".prealable (sigle, sigleprealable) values (_sigle, _sigleprealable);
        end;

        create or replace procedure retirerPrealable(_sigle "MDD".sigle, _sigleprealable "MDD".sigle)
            external security definer
        begin
            atomic
            delete from "MDD".prealable where sigle = _sigle and sigleprealable = _sigleprealable;
        end;
--  Attribuer, modifier : une note à un étudiant en regard d’une inscription à un groupe.

        create or replace procedure attribuerNote(_matriculee "MDD".matriculee, _sigle "MDD".sigle,
                                                  _trimestre "MDD".trimestre, _nogroupe "MDD".nogroupe,
                                                  _note "MDD".note)
            external security definer
        begin
            atomic
            insert into "MDD".evaluation (matriculee, sigle, trimestre, nogroupe, note)
            VALUES (_matriculee, _sigle, _trimestre, _nogroupe, _note);
        end;

        create or replace procedure modifierNote(_matriculee "MDD".matriculee, _sigle "MDD".sigle,
                                                 _trimestre "MDD".trimestre, _nogroupe "MDD".nogroupe, _note "MDD".note)
            external security definer
        begin
            atomic
            update "MDD".evaluation
            set note = _note
            where matriculee = _matriculee
              and sigle = _sigle
              and trimestre = _trimestre
              and nogroupe = _nogroupe;
        end;
        --
--  TODO 2021-03-19 (LL01) : Attribuer, modifier : une note à un étudiant en regard d’une inscription à un groupe.

        --
--  Déterminer si un étudiant remplit les conditions préalables à un cours.
--
--  TODO 2021-03-19 (LL01) : Déterminer si un étudiant remplit les conditions préalables à un cours.
        create or replace function remplitConditionsPrealables(_matriculee "MDD".matriculee,
                                                     _sigle "MDD".sigle)
            returns boolean
        as $$
        DECLARE
            row RECORD;
            _sigle "MDD".sigle = _sigle;
            _matriculee "MDD".matriculee = _matriculee;

        begin
                   for row in (select sigleprealable
                                           from "MDD".prealable
                                           where sigle = _sigle)
                       loop

                        if exists(select * from  "MDD".evaluation where sigle = row.sigleprealable and matriculee = _matriculee)
                            then
                            else
                            return false;
                        end if;

                       end loop;
        return true ;


        end;
$$ language plpgsql;


        --
--  Déterminer si l’offre effective est en accord avec l’offre planifiée.
--

        create or replace function Offre_plan_non_couverte()
            returns table
                    (
                        sigle     "MDD".sigle,
                        trimestre "MDD".trimestre
                    )
            language sql
        as
        $$
        select sigle, trimestre
        from Offre
        except
        select distinct sigle, trimestre
        from Affectation
        $$;
        comment on function Offre_plan_non_couverte () is
            'Détermine les cours de l’offre (planifiée) non couverts par l’affection (offre effective).';

        create or replace function Offre_eff_conforme() returns boolean
            language sql as
        $$
        select not exists(select * from Offre_plan_non_couverte())
        $$;
        comment on function Offre_eff_conforme () is
            'Détermine si l’affection (offre effective) est conforme à l’offre (planifiée).';

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
