Ce mod permet la culture des fleurs et nénuphars de base de minetest.

Il n'est pas totalement réaliste, le compost ne mâturant pas de cette façon, mais
il s'inspire de la réalité, et j'avais envie de faire un système un peu différent
pour faire pousser les fleurs qu'un simple champ autour d'un point d'eau.

Pour ce faire vous devez d'abord fabriquer du compost.

Schéma de la fabrication du compost :

    ╔══════════╦══════════╦══════════╗
    ║          ║          ║          ║
    ║ BLOC DE  ║ FEUILLAGE║ BLOC DE  ║
    ║  TERRE   ║ (groupe) ║  TERRE   ║
    ║          ║          ║          ║
    ║          ║          ║          ║
    ╠══════════╬══════════╬══════════╣
    ║          ║          ║          ║
    ║FEUILLAGE ║   SEAU   ║ FEUILLAGE║
    ║ (groupe) ║   D'EAU  ║ (groupe) ║ ==> 8 blocs de compost
    ║          ║          ║          ║
    ║          ║          ║          ║
    ╠══════════╬══════════╬══════════╣
    ║          ║          ║          ║
    ║ BLOC DE  ║ FEUILLAGE║ BLOC DE  ║
    ║  TERRE   ║ (groupe) ║  TERRE   ║
    ║          ║          ║          ║
    ║          ║          ║          ║
    ╚══════════╩══════════╩══════════╝

En l'état, ce compost n'est pas arable (cultivable), il a besoin de mâturer un
certain temps à l'abri de toute lumière (0) pour pouvoir évoluer en un bloc de
compost fertile (2 phases), pour ce faire vous devez le placer dans un endroit
totalement sombre ou encore l'enterrer entre des blocs opaques.

Ensuite vous aurez besoin d'un sécateur pour collecter les « boutures » de
fleurs et des embryons de nénuphars.


Schéma de la fabrication du sécateur :

    ╔══════════╦══════════╦══════════╗
    ║          ║          ║          ║
    ║          ║  LINGOT  ║          ║
    ║          ║  DE FER  ║          ║
    ║          ║          ║          ║
    ║          ║          ║          ║
    ╠══════════╬══════════╬══════════╣
    ║          ║          ║          ║
    ║          ║          ║  LINGOT  ║
    ║  BÂTON   ║  BÂTON   ║  DE FER  ║ ==> 1 sécateur
    ║          ║          ║          ║
    ║          ║          ║          ║
    ╠══════════╬══════════╬══════════╣
    ║          ║          ║          ║
    ║          ║          ║          ║
    ║          ║  BÂTON   ║          ║
    ║          ║          ║          ║
    ║          ║          ║          ║
    ╚══════════╩══════════╩══════════╝

Ceci fait, il suffit d'effectuer un clic droit avec cet outil sur une fleur pour
collecter les boutures (je sais, ça ressemble plus à des graines qu'à des boutures).
Même fonctionnement sur les nénuphars pour en collecter des embryons.

Il ne vous reste plus qu'à planter ces boutures de fleurs sur du compost fertile
et d'attendre que cela pousse pour donner une fleur.

La reproduction des nénuphars nécessite un peu plus de préparations, vous devez
tout d'abord placer un bloc de compost fertile sous une et une seule couche
d'eau, qui doit elle même se situer en dessous de l'air.

    ╔══════════╗
    ║          ║
    ║          ║
    ║   AIR    ║
    ║          ║
    ║          ║
    ╠══════════╣
    ║          ║
    ║          ║
    ║   EAU    ║
    ║          ║
    ║          ║
    ╠══════════╣
    ║          ║
    ║  COMPOST ║
    ║  FERTILE ║
    ║          ║
    ║          ║
    ╚══════════╝

Ceci fait, vous devez attendre un certain laps de temps que le compost se diffuse
dans l'eau, il deviendra un bloc de terre suite à cette action et l'eau se sera
transformée en eau fertile, vous pourrez désormais placer les embryons de nénuphars
sur cette eau fertilisée pour que les nénuphars puissent grandir.
Vous pouvez évidemment déplacer cette eau vers un autre endroit avec le seau.


Notes additionnelles :

Il faut un niveau de lumière minimale de 10 (par défaut) pour que les fleurs et nénuphars puissent croître.
Par défaut la croissance ne se fait que lors de la journée.
Il y a 3 phases intermédiaires entre la graine et la fleur finale.
Il y a 2 phases intermédiares entre l'embryon et le nénuphar final.
Il n'est pas possible d'obtenir une source éternelle (comme pour l'eau) d'eau fertilisée.
