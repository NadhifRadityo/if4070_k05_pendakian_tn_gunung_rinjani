:- dynamic triple/3.
:- multifile aturan/3.
:- dynamic aturan/3.


classify(Individu, Kelas) :-
    nonvar(Individu), nonvar(Kelas),
    Goal =.. [Kelas, Individu],
    with_limit(once(prove(Goal, 0, _))).   

explain(classify(Individu, Kelas), Evidence) :-      
    nonvar(Individu), nonvar(Kelas),
    Goal =.. [Kelas, Individu],
    with_limit(once(prove(Goal, 0, Evidence))).

why_not(classify(Individu, Kelas), DaftarGagal) :-
    why_not(Individu, Kelas, DaftarGagal).

why_not(Individu, Kelas, DaftarGagal) :-
    nonvar(Individu), nonvar(Kelas),
    Goal =.. [Kelas, Individu],
    findall(gagal(Id, FailedGoal), (
        aturan(Id, Head, Body),
        copy_term((Head,Body), (HeadCopy,BodyCopy)),
        HeadCopy = Goal,
        first_failure(BodyCopy, FailedGoal)
    ), Raw),
    sort(Raw, DaftarGagal).

with_limit(G) :-                                     
    catch(call_with_time_limit(5, G), time_limit_exceeded, fail).

prove(Goal, Depth, Evidence) :-
    Depth < 64,
    prove_goal(Goal, Depth, Evidence).

prove_goal(Goal, _, fakta(Goal)) :-
    Goal =.. [Class, Individual],
    triple(Individual, rdf_type, Class), !.
prove_goal(triple(S,P,O), _, fakta(triple(S,P,O))) :-
    triple(S,P,O).

prove_goal((A,B), Depth, and(EA,EB)) :-
    D1 is Depth + 1,
    prove(A, D1, EA),
    prove(B, D1, EB), !.

prove_goal(\+ Goal, _, tidak(Goal)) :-
    \+ prove(Goal, 1, _), !.

prove_goal(Goal, Depth, bukti(Id, HeadCopy, BodyList)) :-
    aturan(Id, Head, Body),
    copy_term((Head,Body), (HeadCopy,BodyCopy)),
    Goal = HeadCopy,
    D1 is Depth + 1,
    prove(BodyCopy, D1, BodyEvidence),
    evidence_list(BodyEvidence, BodyList), !. 

prove_goal(Goal, _, fakta(Goal)) :-
    callable(Goal),
    builtin_goal(Goal),
    call(Goal), !.
prove_goal(Goal, _, fakta(Goal)) :-
    callable(Goal),
    functor(Goal, Name, Arity),
    current_predicate(Name/Arity),
    catch(call(Goal), error(existence_error(procedure, _), _), fail), !.

evidence_list(and(EA,EB), [EA|Rest]) :- !,            
    evidence_list(EB, Rest).
evidence_list(E, [E]).

builtin_goal(Goal) :-
    functor(Goal, Name, Arity),
    memberchk(Name-Arity,
      [ is-2, '>'-2, '>='-2, '<'-2, '=<' -2, '=:='-2, '=\\='-2,
        '='-2, '=='-2, '\\=='-2, dif-2,
        member-2, memberchk-2, between-3,
        length-2, sort-2, msort-2, sum_list-2,
        aggregate_all-3, aggregate_all-4,
        date_time_stamp-2
      ]).

first_failure((A,B), Failed) :-
    ( prove(A, 0, _) -> first_failure(B, Failed)
    ; Failed = A
    ), !.
first_failure(\+ A, Failed) :-
    ( prove(A, 0, _) -> Failed = (\+ A) ; fail ), !.
first_failure(Goal, Goal) :-
    \+ prove(Goal, 0, _).


% aturan(IdAturan, Head, Body)

% didampingi_oleh inverseOf mendampingi
aturan(inv_didampingi_oleh, didampingi_oleh(X, Y), triple(X, didampingi_oleh, Y)).
aturan(inv_didampingi_oleh, didampingi_oleh(X, Y), triple(Y, mendampingi, X)).
aturan(inv_mendampingi, mendampingi(X, Y), triple(X, mendampingi, Y)).
aturan(inv_mendampingi, mendampingi(X, Y), triple(Y, didampingi_oleh, X)).

% subsumption
aturan(sub_guide_pemandu, pemandu_gunung(X), guide(X)).
aturan(sub_porter_pemandu, pemandu_gunung(X), porter(X)).
aturan(sub_nusantara_pendaki, pendaki(X), pendaki_nusantara(X)).
aturan(sub_mancanegara_pendaki, pendaki(X), pendaki_mancanegara(X)).
aturan(sub_berpengalaman_pendaki, pendaki(X), pendaki_berpengalaman(X)).
aturan(sub_premium_asuransi, asuransi(X), asuransi_premium(X)).
aturan(sub_standar_asuransi, asuransi(X), asuransi_standar(X)).

aturan(dom_usia_pendaki, pendaki(X), triple(X, usia, _)).
aturan(r01, pendaki_siap_bayar(X),
       (pendaki(X),
        triple(X, kuota_tersedia, true),
        triple(X, data_booking_terisi, true),
        triple(X, informed_consent_terisi, true),
        triple(X, data_asuransi_terisi, true))).
aturan(r02, pendaki_berbayar(X),
       (pendaki_siap_bayar(X),
        triple(X, pembayaran_terkonfirmasi, true))).
aturan(r02, memiliki_e_tiket(X, T), triple(X, memiliki_e_tiket, T)).
aturan(r02, memiliki_e_tiket(X, etiket(X)), pendaki_berbayar(X)).
aturan(r02, e_tiket(etiket(X)), pendaki_berbayar(X)).
aturan(r03, pendaki_check_in_lengkap(X),
       (pendaki(X),
        memiliki_e_tiket(X, T),
        e_tiket(T),
        triple(X, identitas_berlaku, true),
        triple(X, surat_sehat_h_min_1, true))).
aturan(r04, pendaki_pack_in(X),
       (pendaki_kemasan_sesuai(X),
        triple(X, perlengkapan_sesuai_checklist, true))).
aturan(r05, pendaki_diizinkan_mendaki(X),
       (pendaki_check_in_lengkap(X),
        pendaki_pack_in(X),
        triple(X, check_in_terverifikasi, true),
        triple(X, safety_briefing_diikuti, true))).
aturan(r06, kelompok_valid(K),
       (kelompok(K),
        anggota_pendaki(K, Anggota),
        length(Anggota, N),
        N >= 2)).
aturan(r06, pendaki_terdampingi(X),
       (pendaki(X),
        didampingi_oleh(X, Y),
        pemandu_gunung(Y))).
aturan(r06, pendaki_terdampingi(X),
       (pendaki(X),
        didampingi_oleh(X, Y),
        pendaki_berpengalaman(Y))).
aturan(r06, pendaki_nusantara_terdampingi(X),
       (pendaki_nusantara(X),
        pendaki_terdampingi(X))).
aturan(r07, pendaki_mancanegara_ber_t_o(X),
       (pendaki_mancanegara(X),
        triple(X, menggunakan_jasa, T),
        trekking_organizer(T))).
aturan(r07, pendaki_mancanegara_registrasi_sesuai(X),
       (pendaki_mancanegara_ber_t_o(X),
        triple(X, persetujuan_t_o_diperoleh, true))).
aturan(r07, pendaki_mancanegara_registrasi_sesuai(X),
       (pendaki_mancanegara_ber_t_o(X),
        triple(X, registrasi_langsung, false))).
aturan(r08, rasio_guide_sesuai(G),
       (guide(G),
        triple(G, bekerja_pada, T),
        trekking_organizer(T),
        pendaki_didampingi(G, Pendaki),
        length(Pendaki, N),
        N =< 4,
        triple(G, beban_kg, Beban),
        Beban =< 15)).
aturan(r08, rasio_guide_sesuai(G),
       (guide(G),
        triple(G, tanggal_pendakian, Tanggal),
        sebelum_ketentuan_2026(Tanggal))).
aturan(r09, asuransi_pendaki_sesuai(X),
       (pendaki(X),
        triple(X, memiliki_asuransi, A),
        asuransi_premium(A))).
aturan(r09, asuransi_pendaki_sesuai(X),
       (pendaki(X),
        triple(X, tanggal_pendakian, Tanggal),
        sebelum_ketentuan_2026(Tanggal),
        triple(X, memiliki_asuransi, A),
        asuransi(A))).
aturan(r09, asuransi_pemandu_sesuai(X),
       (pemandu_gunung(X),
        triple(X, memiliki_asuransi, A),
        asuransi_standar(A))).
aturan(r10, pendaki_anak(X),
       (pendaki(X),
        triple(X, usia, U),
        U < 17)).
aturan(r10, pendaki_anak_memenuhi_syarat(X),
       (pendaki_anak(X),
        didampingi_oleh(X, Y),
        guide(Y),
        triple(X, izin_orang_tua_diserahkan, true))).
aturan(r10, pendaki_anak_memenuhi_syarat(X),
       (pendaki_anak(X),
        didampingi_oleh(X, Y),
        pendaki_berpengalaman(Y),
        triple(Y, usia, U),
        U > 17,
        triple(X, izin_orang_tua_diserahkan, true))).
aturan(r11, pendaki_jalur_sesuai(X),
       (pendaki(X),
        triple(X, jalur_sesuai_e_tiket, true),
        triple(X, waktu_sesuai_e_tiket, true))).
aturan(r11, pendaki_jalur_sesuai(X),
       (pendaki(X),
        triple(X, pendakian_khusus, true),
        triple(X, pemberitahuan_bersyarat_dipenuhi, true))).
aturan(r12, pendaki_kewajiban_pendakian_terpenuhi(X),
       (pendaki(X),
        triple(X, menyimpan_e_tiket, true),
        triple(X, menyimpan_checklist_sampah, true),
        triple(X, membawa_trash_bag, true))).
aturan(r13, pendaki_check_out_lengkap(X),
       (pendaki(X),
        triple(X, pack_out_dilakukan, true),
        triple(X, check_out_dilakukan, true),
        triple(X, durasi_sesuai_tiket, true),
        triple(X, sampah_pilahan_diserahkan, true))).
aturan(r14, pendaki_kemasan_sesuai(X),
       (pendaki(X),
        triple(X, wadah_guna_ulang, true),
        triple(X, barang_kemasan_terlarang, false))).
aturan(r15, aktivitas_pada_satwa_terlarang(A),
       (aktivitas_pada_satwa(A),
        triple(A, tindakan_satwa_umum, true))).
aturan(r15, aktivitas_memancing_diperbolehkan(A),
       (aktivitas_pada_satwa(A),
        triple(A, memancing_di_tepi_danau_segara_anak, true),
        triple(A, tindakan_satwa_umum, false))).
aturan(r16, penyedia_memenuhi_ambang(P),
       (penyedia_makanan_minuman(P),
        triple(P, persen_produk_lokal, Persen),
        Persen >= 25)).
aturan(r17, pelanggaran_ringan(E),
       (pelanggaran(E),
        triple(E, nomor_aturan, N),
        kategori_nomor(N, ringan))).
aturan(r17, pelanggaran_sedang(E),
       (pelanggaran(E),
        triple(E, nomor_aturan, N),
        kategori_nomor(N, sedang))).
aturan(r17, pelanggaran_berat(E),
       (pelanggaran(E),
        triple(E, nomor_aturan, N),
        kategori_nomor(N, berat))).
aturan(r18, pelaku_akumulasi_sedang(P),
       (jumlah_kejadian(P, ringan, N),
        N >= 3,
        \+ pelaku_akumulasi_berat(P))).
aturan(r19, pelaku_akumulasi_berat(P),
       (jumlah_sedang_efektif(P, N),
        N >= 2)).
aturan(r20, pendaki_overtime_wajib_lapor_dan_denda(X),
       (pendaki(X),
        triple(X, durasi_hari_overtime, D),
        D >= 1,
        \+ pendaki_overtime_dikecualikan(X))).
aturan(r20, pendaki_overtime_auto_blacklist(X),
       (pendaki_overtime_wajib_lapor_dan_denda(X),
        triple(X, durasi_hari_overtime, D),
        D > 3)).
aturan(r21, pendaki_overtime_dikecualikan(X),
       (pendaki(X),
        triple(X, durasi_hari_overtime, D),
        D >= 1,
        triple(X, penyebab_overtime, Sebab),
        penyebab_overtime_diakui(Sebab),
        triple(X, melapor_ke_petugas, true),
        triple(X, bukti_diserahkan, true))).
aturan(r22, pendaki_mendapat_refund(X),
       (pendaki(X),
        triple(X, dibatalkan_mendaki_karena, S),
        force_majeure(S))).
aturan(r22, pendaki_mendapat_refund(X),
       (pendaki(X),
        triple(X, dibatalkan_mendaki_karena, S),
        gangguan_sistem(S))).
aturan(r22, pendaki_mendapat_refund(X),
       (pendaki(X),
        triple(X, dibatalkan_mendaki_karena, S),
        penutupan_insidental(S))).

kategori_nomor(N, ringan) :- integer(N), N >= 27, N =< 31.
kategori_nomor(N, sedang) :- integer(N), N >= 25, N =< 26.
kategori_nomor(N, berat) :- integer(N), N >= 1, N =< 24.
nilai_kategori(ringan, 1).
nilai_kategori(sedang, 3).
nilai_kategori(berat, 6).
penyebab_overtime_diakui(sakit).
penyebab_overtime_diakui(cuaca_ekstrem).
penyebab_overtime_diakui(kecelakaan).
penyebab_overtime_diakui(cedera).
sebelum_ketentuan_2026(date(Y, M, D)) :-
    date(Y, M, D) @< date(2026, 1, 1).
adalah_pendaki(X) :-
    prove(pendaki(X), 0, _).
anggota_pendaki(K, Anggota) :-
    findall(P, (triple(K, beranggota, P), adalah_pendaki(P)), Semua),
    sort(Semua, Anggota).
pendaki_didampingi(G, Pendaki) :-
    findall(P, (pasangan_pendamping(G, P), adalah_pendaki(P)), Semua),
    sort(Semua, Pendaki).

pasangan_pendamping(G, P) :- triple(G, mendampingi, P).
pasangan_pendamping(G, P) :- triple(P, didampingi_oleh, G).
jumlah_kejadian(Pelaku, Kategori, N) :-
    findall(E,
            (triple(E, dilakukan_oleh, Pelaku),
             triple(E, rdf_type, pelanggaran),
             triple(E, nomor_aturan, Nomor),
             kategori_nomor(Nomor, Kategori)),
            Semua),
    sort(Semua, Kejadian),
    length(Kejadian, N).
jumlah_sedang_efektif(Pelaku, N) :-
    jumlah_kejadian(Pelaku, sedang, Sedang),
    jumlah_kejadian(Pelaku, ringan, Ringan),
    N is Sedang + Ringan // 3.

