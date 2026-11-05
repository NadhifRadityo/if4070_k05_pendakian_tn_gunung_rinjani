:- begin_tests(reasoner).
:- consult('../src/kb.pl').
:- consult('../src/demo_rules.pl').

setup_facts :-
    retractall(triple(_,_,_)),
    assertz(triple(andi, kuota_tersedia, true)),
    assertz(triple(andi, data_booking_lengkap, true)),
    assertz(triple(andi, informed_consent, true)),
    assertz(triple(andi, data_asuransi, true)),
    assertz(triple(andi, pembayaran_terkonfirmasi, true)),
    assertz(triple(andi, email_terdaftar, true)),
    assertz(triple(andi, identitas_valid, true)),
    assertz(triple(andi, surat_sehat_sesuai, true)),
    assertz(triple(andi, packin_lolos, true)),
    assertz(triple(andi, safety_briefing, true)),
    assertz(triple(budi, pendaki, true)),
    assertz(triple(citra, jumlah_pendaki, 5)),
    assertz(triple(citra, beban_guide_kg, 14)).

test(chained_inference, [setup(setup_facts)]) :-
    classify(andi, pendaki_diizinkan_memulai).
test(classify_outside_abox_is_false, [setup(setup_facts), fail]) :-
    classify(individu_baru, pendaki_diizinkan_memulai).
test(negation_success, [setup(setup_facts)]) :-
    classify(budi, bebas_kemasan_terlarang).
test(numeric_comparison_failure, [setup(setup_facts), fail]) :-
    classify(citra, rasio_guide_terpenuhi).
test(explanation_shape, [setup(setup_facts)]) :-
    once(prove(pendaki_diizinkan_memulai(andi), 0, bukti(_,_,_))).
test(why_not_has_failed_goal, [setup(setup_facts)]) :-
    why_not(citra, rasio_guide_terpenuhi, Failures),
    member(gagal(r_test_numeric, _), Failures).

:- end_tests(reasoner).

:- initialization(main, main).
main :-
    run_tests,
    halt.
