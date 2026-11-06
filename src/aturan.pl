% aturan(IdAturan, Head, Body)
:- multifile aturan/3.
:- dynamic aturan/3.

% didampingiOleh inverseOf mendampingi
aturan(inv_didampingi_oleh, didampingiOleh(X, Y), triple(X, didampingiOleh, Y)).
aturan(inv_didampingi_oleh, didampingiOleh(X, Y), triple(Y, mendampingi, X)).
aturan(inv_mendampingi, mendampingi(X, Y), triple(X, mendampingi, Y)).
aturan(inv_mendampingi, mendampingi(X, Y), triple(Y, didampingiOleh, X)).

% subsumption
aturan(sub_guide_pemandu, 'PemanduGunung'(X), 'Guide'(X)).
aturan(sub_porter_pemandu, 'PemanduGunung'(X), 'Porter'(X)).
aturan(sub_nusantara_pendaki, 'Pendaki'(X), 'PendakiNusantara'(X)).
aturan(sub_mancanegara_pendaki, 'Pendaki'(X), 'PendakiMancanegara'(X)).
aturan(sub_berpengalaman_pendaki, 'Pendaki'(X), 'PendakiBerpengalaman'(X)).
aturan(sub_premium_asuransi, 'Asuransi'(X), 'AsuransiPremium'(X)).
aturan(sub_standar_asuransi, 'Asuransi'(X), 'AsuransiStandar'(X)).

aturan(dom_usia_pendaki, 'Pendaki'(X), triple(X, usia, _)).
aturan(r01, 'PendakiSiapBayar'(X),
       ('Pendaki'(X),
        triple(X, kuotaTersedia, true),
        triple(X, dataBookingTerisi, true),
        triple(X, informedConsentTerisi, true),
        triple(X, dataAsuransiTerisi, true))).
aturan(r02, 'PendakiBerbayar'(X),
       ('PendakiSiapBayar'(X),
        triple(X, pembayaranTerkonfirmasi, true))).
aturan(r02, memilikiETiket(X, T), triple(X, memilikiETiket, T)).
aturan(r02, memilikiETiket(X, etiket(X)), 'PendakiBerbayar'(X)).
aturan(r02, 'ETiket'(etiket(X)), 'PendakiBerbayar'(X)).
aturan(r03, 'PendakiCheckInLengkap'(X),
       ('Pendaki'(X),
        memilikiETiket(X, T),
        'ETiket'(T),
        triple(X, identitasBerlaku, true),
        triple(X, 'suratSehatH-1', true))).
aturan(r04, 'PendakiPackIn'(X),
       ('PendakiKemasanSesuai'(X),
        triple(X, perlengkapanSesuaiChecklist, true))).
aturan(r05, 'PendakiDiizinkanMendaki'(X),
       ('PendakiCheckInLengkap'(X),
        'PendakiPackIn'(X),
        triple(X, checkInTerverifikasi, true),
        triple(X, safetyBriefingDiikuti, true))).
aturan(r06, 'KelompokValid'(K),
       ('Kelompok'(K),
        anggota_pendaki(K, Anggota),
        length(Anggota, N),
        N >= 2)).
aturan(r06, 'PendakiTerdampingi'(X),
       ('Pendaki'(X),
        didampingiOleh(X, Y),
        'PemanduGunung'(Y))).
aturan(r06, 'PendakiTerdampingi'(X),
       ('Pendaki'(X),
        didampingiOleh(X, Y),
        'PendakiBerpengalaman'(Y))).
aturan(r06, 'PendakiNusantaraTerdampingi'(X),
       ('PendakiNusantara'(X),
        'PendakiTerdampingi'(X))).
aturan(r07, 'PendakiMancanegaraBerTO'(X),
       ('PendakiMancanegara'(X),
        triple(X, menggunakanJasa, T),
        'TrekkingOrganizer'(T))).
aturan(r07, 'PendakiMancanegaraRegistrasiSesuai'(X),
       ('PendakiMancanegaraBerTO'(X),
        triple(X, persetujuanTODiperoleh, true))).
aturan(r07, 'PendakiMancanegaraRegistrasiSesuai'(X),
       ('PendakiMancanegaraBerTO'(X),
        triple(X, registrasiLangsung, false))).
aturan(r08, 'RasioGuideSesuai'(G),
       ('Guide'(G),
        triple(G, bekerjaPada, T),
        'TrekkingOrganizer'(T),
        pendaki_didampingi(G, Pendaki),
        length(Pendaki, N),
        N =< 4,
        triple(G, bebanKg, Beban),
        Beban =< 15)).
aturan(r08, 'RasioGuideSesuai'(G),
       ('Guide'(G),
        triple(G, tanggalPendakian, Tanggal),
        sebelum_ketentuan_2026(Tanggal))).
aturan(r09, 'AsuransiPendakiSesuai'(X),
       ('Pendaki'(X),
        triple(X, memilikiAsuransi, A),
        'AsuransiPremium'(A))).
aturan(r09, 'AsuransiPendakiSesuai'(X),
       ('Pendaki'(X),
        triple(X, tanggalPendakian, Tanggal),
        sebelum_ketentuan_2026(Tanggal),
        triple(X, memilikiAsuransi, A),
        'Asuransi'(A))).
aturan(r09, 'AsuransiPemanduSesuai'(X),
       ('PemanduGunung'(X),
        triple(X, memilikiAsuransi, A),
        'AsuransiStandar'(A))).
aturan(r10, 'PendakiAnak'(X),
       ('Pendaki'(X),
        triple(X, usia, U),
        U < 17)).
aturan(r10, 'PendakiAnakMemenuhiSyarat'(X),
       ('PendakiAnak'(X),
        didampingiOleh(X, Y),
        'Guide'(Y),
        triple(X, izinOrangTuaDiserahkan, true))).
aturan(r10, 'PendakiAnakMemenuhiSyarat'(X),
       ('PendakiAnak'(X),
        didampingiOleh(X, Y),
        'PendakiBerpengalaman'(Y),
        triple(Y, usia, U),
        U > 17,
        triple(X, izinOrangTuaDiserahkan, true))).
aturan(r11, 'PendakiJalurSesuai'(X),
       ('Pendaki'(X),
        triple(X, jalurSesuaiETiket, true),
        triple(X, waktuSesuaiETiket, true))).
aturan(r11, 'PendakiJalurSesuai'(X),
       ('Pendaki'(X),
        triple(X, pendakianKhusus, true),
        triple(X, pemberitahuanBersyaratDipenuhi, true))).
aturan(r12, 'PendakiKewajibanPendakianTerpenuhi'(X),
       ('Pendaki'(X),
        triple(X, menyimpanETiket, true),
        triple(X, menyimpanChecklistSampah, true),
        triple(X, membawaTrashBag, true))).
aturan(r13, 'PendakiCheckOutLengkap'(X),
       ('Pendaki'(X),
        triple(X, packOutDilakukan, true),
        triple(X, checkOutDilakukan, true),
        triple(X, durasiSesuaiTiket, true),
        triple(X, sampahPilahanDiserahkan, true))).
aturan(r14, 'PendakiKemasanSesuai'(X),
       ('Pendaki'(X),
        triple(X, wadahGunaUlang, true),
        triple(X, barangKemasanTerlarang, false))).
aturan(r15, 'AktivitasPadaSatwaTerlarang'(A),
       ('AktivitasPadaSatwa'(A),
        triple(A, tindakanSatwaUmum, true))).
aturan(r15, 'AktivitasMemancingDiperbolehkan'(A),
       ('AktivitasPadaSatwa'(A),
        triple(A, memancingDiTepiDanauSegaraAnak, true),
        triple(A, tindakanSatwaUmum, false))).
aturan(r16, 'PenyediaMemenuhiAmbang'(P),
       ('PenyediaMakananMinuman'(P),
        triple(P, persenProdukLokal, Persen),
        Persen >= 25)).
aturan(r17, 'PelanggaranRingan'(E),
       ('Pelanggaran'(E),
        triple(E, nomorAturan, N),
        kategori_nomor(N, ringan))).
aturan(r17, 'PelanggaranSedang'(E),
       ('Pelanggaran'(E),
        triple(E, nomorAturan, N),
        kategori_nomor(N, sedang))).
aturan(r17, 'PelanggaranBerat'(E),
       ('Pelanggaran'(E),
        triple(E, nomorAturan, N),
        kategori_nomor(N, berat))).
aturan(r18, 'PelakuAkumulasiSedang'(P),
       (jumlah_kejadian(P, ringan, N),
        N >= 3,
        \+ 'PelakuAkumulasiBerat'(P))).
aturan(r19, 'PelakuAkumulasiBerat'(P),
       (jumlah_sedang_efektif(P, N),
        N >= 2)).
aturan(r20, 'PendakiOvertimeWajibLaporDanDenda'(X),
       ('Pendaki'(X),
        triple(X, durasiHariOvertime, D),
        D >= 1,
        \+ 'PendakiOvertimeDikecualikan'(X))).
aturan(r20, 'PendakiOvertimeAutoBlacklist'(X),
       ('PendakiOvertimeWajibLaporDanDenda'(X),
        triple(X, durasiHariOvertime, D),
        D > 3)).
aturan(r21, 'PendakiOvertimeDikecualikan'(X),
       ('Pendaki'(X),
        triple(X, durasiHariOvertime, D),
        D >= 1,
        triple(X, penyebabOvertime, Sebab),
        penyebab_overtime_diakui(Sebab),
        triple(X, melaporKePetugas, true),
        triple(X, buktiDiserahkan, true))).
aturan(r22, 'PendakiMendapatRefund'(X),
       ('Pendaki'(X),
        triple(X, dibatalkanMendakiKarena, S),
        'ForceMajeure'(S))).
aturan(r22, 'PendakiMendapatRefund'(X),
       ('Pendaki'(X),
        triple(X, dibatalkanMendakiKarena, S),
        'GangguanSistem'(S))).
aturan(r22, 'PendakiMendapatRefund'(X),
       ('Pendaki'(X),
        triple(X, dibatalkanMendakiKarena, S),
        'PenutupanInsidental'(S))).

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
    prove('Pendaki'(X), 0, _).
anggota_pendaki(K, Anggota) :-
    findall(P, (triple(K, beranggota, P), adalah_pendaki(P)), Semua),
    sort(Semua, Anggota).
pendaki_didampingi(G, Pendaki) :-
    findall(P, (pasangan_pendamping(G, P), adalah_pendaki(P)), Semua),
    sort(Semua, Pendaki).

pasangan_pendamping(G, P) :- triple(G, mendampingi, P).
pasangan_pendamping(G, P) :- triple(P, didampingiOleh, G).
jumlah_kejadian(Pelaku, Kategori, N) :-
    findall(E,
            (triple(E, dilakukanOleh, Pelaku),
             triple(E, rdf:type, 'Pelanggaran'),
             triple(E, nomorAturan, Nomor),
             kategori_nomor(Nomor, Kategori)),
            Semua),
    sort(Semua, Kejadian),
    length(Kejadian, N).
jumlah_sedang_efektif(Pelaku, N) :-
    jumlah_kejadian(Pelaku, sedang, Sedang),
    jumlah_kejadian(Pelaku, ringan, Ringan),
    N is Sedang + Ringan // 3.
