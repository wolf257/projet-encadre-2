#!/usr/bin/env/ perl -w

use XML::RSS;

# VAR ===========================================================
# nom du répertoire où se trouvent les fichiers à traiter
my $folder=$ARGV[0];

# évitons les doubles backslashes
# ainsi cela devient pareil de lui donner folder ou folder/
$folder=~ s/[\/]$//;
print "+ Nom du dossier à parcourir : $folder\n\n";

my $rss=new XML::RSS;

my $rubriqueATraiter;
# my $rubriqueATraiter=$ARGV[1];

my %nom_des_rubriques = (
    "0,2-651865,1-0,0" => 'Technologie',
    "0,2-3260,1-0,0" => 'Livres',
    "0,2-3234,1-0,0" => 'Entreprise',
);

my %doublons;

# MAIN ===========================================================

$rubriqueATraiter = &askRubrique;
print "+ Rubrique choisi : '$nom_des_rubriques{$rubriqueATraiter}' dont l'id est : $rubriqueATraiter\n\n";

# Open files output
open(FICOUT, ">:encoding(utf8)", "./sortie-texte.txt") or die("message2");
open(FICOUTXML, ">:encoding(utf8)", "./sortie-xml.xml") or die("message3");

&write_xml_header(FICOUTXML);

# Traitement arbo
my ($compteur_folder, $compteur_file, $compteur_file_matching) = (0, 0, 0);
&gothroughtree($folder, $rubriqueATraiter);

print "\nRésultat de gothroughtree : $compteur_folder dossiers, et $compteur_file fichiers.\n";
print "- $compteur_file_matching fichiers appartenant à notre rubrique.";

&write_xml_tail(FICOUTXML);


# Close files output
close(FICOUT);
close(FICOUTXML);

# SUBS ===========================================================

sub askRubrique {

    my %choix_possibles = (
        "1"  => "0,2-651865,1-0,0",
        "2" => "0,2-3260,1-0,0",
        "3"  => "0,2-3234,1-0,0",
        );

    print "Pour vous éviter des erreurs de saisie, choisissez le numéro de la rubrique à traiter :\n";

    while(1){
        print "\tChoix possibles : \n";
        print "\t1 - Technologie\n";
        print "\t2 - Livres\n";
        print "\t3 - Entreprise\n";
        print "\tq - si vous ne savez pas pourquoi vous êtes là. QUIT.\n";
        print "\tLe votre : ";

        chomp (my $choix = <STDIN>);

        exit if $choix eq 'q';

        if (exists ($choix_possibles{$choix}) )
        {
            $rubrique = $choix_possibles{$choix};
            print "\n";
            last;
        } else {
            print "Je n'ai pas compris votre choix. On reprend.\n\n";
            redo;
        }
    }

    # print "Je retourne : $rubrique\n";
    return $rubrique;

}

sub write_xml_header {
    my $fic = shift;
    print $fic "<?xml version=\"1.0\" encoding=\"utf8\" ?>\n";
    print $fic "<racine>\n";
    print $fic "<NOM>GUEYE et DUCHEMIN</NOM>\n\n";

}

sub write_xml_tail {
    my $fic = shift;
    print $fic "</racine>";
}

sub gothroughtree {
    my $path_to_folder = shift(@_);
    my $rubriqueATraiter = shift(@_);

     my @content;
     @content = read_and_return_content_of_folder($path_to_folder);
     # print "Content : @content\.\n";

     # my $compteur = 0;

     foreach my $elt (@content) {

        next if $elt =~ /^\.\.?$/; # on exclut le ./ et ../
        next if $elt =~ /\.(txt|pl)$/; # on exclut le .txt et le .pl
        next if $elt =~ /^\.DS_.*/; # fichier sur Mac

        $path_elt = $path_to_folder."/".$elt;

        # 2 possibilités pour path_elt :
        # - c'est un répertoire, appliquons-lui à nouveau gothroughtree
        # - c'est un fichier, travaillons

        # OPTION 1 : répertoire :
        if (-d $path_elt) {
            # print "== DEBUT REP == \n";
            # print "\n\n--> FOLDER : $path_elt";

            $compteur_folder++;
            &gothroughtree($path_elt, $rubriqueATraiter);

        } # fin du if -d

        # OPTION 2 : fichier:
        elsif (-f $path_elt){
            $compteur_file++;

            # print "\n--> FILE : $path_elt ";

            if ($path_elt =~ /$rubriqueATraiter\.xml/) {
                $compteur_file_matching++;
                print "++ $path_elt correspond.\n";
            }


        } # fin du elsif -f

    } # find du foreach

} # fin du gothroughtree

sub read_and_return_content_of_folder {
    # - Ouvre le dossier donné en arg
    # - Récupère tous les fichiers/répertoires
    # readdir in list : all the content of the directory is read in the memory in one statement
    # See : https://perlmaven.com/reading-the-content-of-a-directory

    $folder = shift;

    opendir(FOLDER, $folder) or die("Je n'arrive pas à ouvrir $folder.\n Erreur: $!\n");
    my @content = readdir(FOLDER);
    closedir(FOLDER);

    return @content;
}
# # 1/ Lecture fichier rss en 1 seule ligne (L)
# my $fic = shift(@ARGV);

# open(FICIN, "<:encoding(utf8)", $fic) or die("message1");
# my $ens_ligne = all_lines_into_one(FICIN);
# close(FICIN);

# sub all_lines_into_one {
#     my $compteur = 0;
#     my $ens_ligne;
#     while (my $line = <FICIN>) {
#         chomp $line;
#         $ens_ligne .= " $line.";
#         $compteur++;
#     }
#     print "Ce fichier comptait $compteur lignes.";
#     return $ens_ligne;
# }
#
#
# # 2/ find in L les occurrences de titre et de description
#
# my $motif = "<item>.*?<title>([^<]*)<\/title>.*?<description>([^<]*)</description>.*?</item>";
#
# my $num_art = 0;
# while ($ens_ligne =~ /$motif/g) {
#     my ($titre, $description) = ($1, $2);
#
#     ($titre, $description) = &cleaning($titre, $description);
#
#     print FICOUT "$titre\n";
#     print FICOUT "$description\n\n";
#
#     print FICOUTXML "\t<titre num_art=\"$num_art\"> $titre </titre>\n";
#     print FICOUTXML "\t<description num_art=\"$num_art\"> $description </description>\n\n";
#
#     $num_art++;
# }
#
# # my $motif = "<item>.*?<title>([^<]*)<\/title>.*?<description>([^<]*)</description>.*?</item>";
# #
# # my $num_art = 0;
# # while ($ens_ligne =~ /$motif/g) {
# #     my ($titre, $description) = ($1, $2);
# #     # my $description = $2;
# #
# #     ($titre, $description) = &cleaning($titre, $description);
# #
# #     print FICOUT "$titre\n";
# #     print FICOUT "$description\n\n";
# #
# #     print FICOUTXML "\t<titre num_art=\"$num_art\"> $titre </titre>\n";
# #     print FICOUTXML "\t<description num_art=\"$num_art\"> $description </description>\n\n";
# #
# #     $num_art++;
# # }
#
#
#
# #---------------------------------------------------------
# sub cleaning {
#     # tous les args sont dans @_
#     my ($t, $d) = @_;
#
#     $t .= ".";
#     $d =~ s/&#38;#39;/'/g;
#
#     return $t, $d;
# }