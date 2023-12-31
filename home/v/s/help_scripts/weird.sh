alias emacs="printf \"\033[31mno\033[0m\n\""

function print_sturdy() {
    echo "+---+---+---+---+---++---+---+---+---+---+"
    echo "┊ V ┊ M ┊ L ┊ C ┊ P    X ┊ F ┊ O ┊ U ┊ J ┊"
    echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
    echo "┊ S ┊ T ┊ R ┊ D ┊ Y    . ┊ N ┊ A ┊ E ┊ I ┊"
    echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
    echo "┊ Z ┊ K ┊ Q ┊ G ┊ W    B ┊ H ┊ ' ┊ ; ┊ , ┊"
    echo "+---+---+---+---+---++---+---+---+---+---+"
}
function print_dvorak() {
	echo "+---+---+---+---+---++---+---+---+---+---+"
	echo "┊ ' ┊ , ┊ . ┊ P ┊ Y    F ┊ G ┊ C ┊ R ┊ L ┊"
	echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
	echo "┊ A ┊ O ┊ E ┊ U ┊ I    D ┊ H ┊ T ┊ N ┊ S ┊"
	echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
	echo "┊ ; ┊ Q ┊ J ┊ K ┊ X    B ┊ M ┊ W ┊ V ┊ Z ┊"
	echo "+---+---+---+---+---++---+---+---+---+---+"
}

function print_semimak_original() {
    echo "+---+---+---+---+---++---+---+---+---+---+"
    echo "┊ F ┊ L ┊ H ┊ V ┊ Z    Q ┊ W ┊ U ┊ O ┊ Y ┊"
    echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
    echo "┊ S ┊ R ┊ N ┊ T ┊ K    C ┊ D ┊ E ┊ A ┊ I ┊"
    echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
    echo "┊ X ┊ ' ┊ B ┊ M ┊ J    P ┊ G ┊ , ┊ . ┊ / ┊"
    echo "+---+---+---+---+---++---+---+---+---+---+"
}
function print_semimak() {
    echo "+---+---+---+---+---++---+---+---+---+---+"
    echo "┊ F ┊ L ┊ H ┊ V ┊ Z    Qü┊ Wù┊ Uû┊ Oô┊ Y ┊"
    echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
    echo "┊ S ┊ R ┊ N ┊ T ┊ K    Cç┊ Dê┊ Eé┊ Aà┊ Iî┊"
    echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
    echo "┊ X ┊ ' ┊ B ┊ M ┊ J    P ┊ G ┊ ,è┊ .â┊ ; ┊"
    echo "+---+---+---+---+---++---+---+---+---+---+"
}
function print_qwerty() {
    echo "+---+---+---+---+---++---+---+---+---+---+"
    echo "┊ Q ┊ W ┊ E ┊ R ┊ T    Y ┊ U ┊ I ┊ O ┊ P ┊"
    echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
    echo "┊ A ┊ S ┊ D ┊ F ┊ G    H ┊ J ┊ K ┊ L ┊ ; ┊"
    echo "┊---┊---┊---┊---┊---  ---┊---┊---┊---┊---┊"
    echo "┊ Z ┊ X ┊ C ┊ V ┊ B    N ┊ M ┊ , ┊ . ┊ / ┊"
    echo "+---+---+---+---+---++---+---+---+---+---+"
}


function typing_guide() {
	google-chrome-stable "https://docs.google.com/document/d/1L-P68VDSGlpLM5A9tfRvWFohaR2NzPbkUT0ok34rsFU/edit"
}

gm() {
	printf "\033[32mgm\033[0m\n"
}
