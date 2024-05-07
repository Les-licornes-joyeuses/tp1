-- Script aménagé depuis celui généré directement par Datagrip (v 2023.2.3) le 2024-04-17

-- Début du script aménagé mig-05-06_v2.sql
--   (avec couplage drop-add par contrainte)

--
-- Définitions des nouvelles fonctions
--

create function "MDD".bureau_dom(t text) returns boolean
  immutable
  language sql
RETURN (t ~ similar_to_escape('[A-Z][0-9]{1,2}-[0-9]{4}(-[0-9]{2})?'::text));

alter function "MDD".bureau_dom(text) owner to lavl1905;

create function "MDD".cause_dom(t text) returns boolean
  immutable
  language sql
RETURN true;

alter function "MDD".cause_dom(text) owner to lavl1905;

create function "MDD".cdc_dom(i smallint) returns boolean
  immutable
  language sql
RETURN ((i >= 1) AND (i <= 90));

alter function "MDD".cdc_dom(smallint) owner to lavl1905;

create function "MDD".matriculee_dom(t text) returns boolean
  immutable
  language sql
RETURN (t ~ similar_to_escape('[a-z]{4}[0-9]{4}'::text));

alter function "MDD".matriculee_dom(text) owner to lavl1905;

create function "MDD".matriculep_dom(t text) returns boolean
  immutable
  language sql
RETURN (t ~ similar_to_escape('[a-z]{4}[0-9]{4}'::text));

alter function "MDD".matriculep_dom(text) owner to lavl1905;

create function "MDD".nogroupe_dom(t text) returns boolean
  immutable
  language sql
RETURN (t ~ similar_to_escape('[0-9]{2}'::text));

alter function "MDD".nogroupe_dom(text) owner to lavl1905;

create function "MDD".nom_dom(t text) returns boolean
  immutable
  language sql
RETURN ((length(t) <= 120) AND (t ~ similar_to_escape('[[:alpha:]]+([-’ [:alpha:]])*[[:alpha:]]+'::text)));

alter function "MDD".nom_dom(text) owner to lavl1905;

create function "MDD".note_dom(i smallint) returns boolean
  immutable
  language sql
RETURN ((i >= 1) AND (i <= 100));

alter function "MDD".note_dom(smallint) owner to lavl1905;

create function "MDD".sigle_dom(t text) returns boolean
  immutable
  language sql
RETURN (t ~ similar_to_escape('[A-Z]{3}[0-9]{3}'::text));

alter function "MDD".sigle_dom(text) owner to lavl1905;

create function "MDD".titre_dom(t text) returns boolean
  immutable
  language sql
RETURN true;

alter function "MDD".titre_dom(text) owner to lavl1905;

create function "MDD".trimestre_dom(t text) returns boolean
  immutable
  language sql
RETURN (t ~ similar_to_escape('[0-9]{4}-[1-3]'::text));

alter function "MDD".trimestre_dom(text) owner to lavl1905;

--
-- Modification des contraintes
--

alter domain "MDD".bureau drop constraint bureau_check;
alter domain "MDD".bureau add constraint bureau_check check ("MDD".bureau_dom(VALUE));

alter domain "MDD".cause add constraint cause_check check ("MDD".cause_dom(VALUE));

alter domain "MDD".cdc drop constraint cdc_check;
alter domain "MDD".cdc add constraint cdc_check check ("MDD".cdc_dom(VALUE));

alter domain "MDD".matriculee drop constraint matriculee_check;
alter domain "MDD".matriculee add constraint matriculee_check check ("MDD".matriculee_dom(VALUE));

alter domain "MDD".matriculep drop constraint matriculep_check;
alter domain "MDD".matriculep add constraint matriculep_check check ("MDD".matriculep_dom(VALUE));

alter domain "MDD".nogroupe drop constraint nogroupe_check;
alter domain "MDD".nogroupe add constraint nogroupe_check check ("MDD".nogroupe_dom(VALUE));

alter domain "MDD".nom drop constraint nom_check;
alter domain "MDD".nom add constraint nom_check check ("MDD".nom_dom(VALUE));

alter domain "MDD".note drop constraint note_check;
alter domain "MDD".note add constraint note_check check ("MDD".note_dom(VALUE));

alter domain "MDD".sigle drop constraint sigle_check;
alter domain "MDD".sigle add constraint sigle_check check ("MDD".sigle_dom(VALUE));

alter domain "MDD".titre add constraint titre_check check ("MDD".titre_dom(VALUE));

alter domain "MDD".trimestre drop constraint trimestre_check;
alter domain "MDD".trimestre add constraint trimestre_check check ("MDD".trimestre_dom(VALUE));

--
-- Modification des commentaires
--

comment on table "MDD".etudiant is 'La personne étudiante (identifiée par le matricule "matriculeE") possède un dossier à l’Université. Son nom est "nom". Sa date de naissance est "ddn". ';

comment on table "MDD".professeur is 'La personne enseignante (identifiée par le matricule "matriculeP") possède un dossier à l’Université. Une personne enseignante est une professeure, un professeur, une chargée de cours ou un chargé de cours. Son nom est "nom". ';

comment on table "MDD".professeur_bureau_pre is 'La personne enseignante (identifiée par le matricule "matriculeP") a un bureau et ce bureau est le "bureau". ';

comment on table "MDD".professeur_bureau_abs is 'La personne enseignante (identifiée par le matricule "matriculeP") n’a pas de bureau pour la raison "cause". ';

comment on table "MDD".cours is 'Le cours (identifié par le sigle "sigle") est défini dans le répertoire des cours offerts par l’Université. Il a pour titre "titre". Il comporte "credit" crédit(s). ';

comment on table "MDD".groupe is 'Le groupe (identifié par le sigle "sigle", le numéro "noGroupe" et le trimestre "trimestre") est constitué. ';

comment on table "MDD".affectation is 'La personne enseignante (identifiée par "matriculeP") assure la formation du groupe identifié par les  sigle "sigle", le numéro "noGroupe" et le trimestre "trimestre". ';

comment on table "MDD".inscription is 'La personne étudiante (identifiée par "matriculeE") est inscrite au groupe identifié par le sigle "sigle", le numéro "noGroupe" et le trimestre "trimestre".';

comment on table "MDD".evaluation is 'La personne étudiante (identifiée par "matriculeE") inscrite au groupe identifié par sigle "sigle", le numéro "noGroupe" et le trimestre "trimestre" a obtenu la note "note". ';

comment on table "MDD".competence is 'La personne enseignante (identifiée par "matriculeP") a la compétence requise pour assure le cours (identifié par le sigle "sigle"). ';

comment on table "MDD".disponibilite is 'La personne enseignante (identifiée par "matriculeP") est disponible pour enseigner durant le trimestre "trimestre". ';

-- Fin du script aménagé mig-05-06_v1.sql