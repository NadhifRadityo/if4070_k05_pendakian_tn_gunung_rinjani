aturan(r01_booking_lengkap, siap_bayar(X),
       (triple(X, kuota_tersedia, true),
        triple(X, data_booking_lengkap, true),
        triple(X, informed_consent, true),
        triple(X, data_asuransi, true))).

aturan(r02_eticket, memiliki_eticket(X),
       (triple(X, pembayaran_terkonfirmasi, true),
        triple(X, email_terdaftar, true))).

aturan(r03_checkin, checkin_lengkap(X),
       (memiliki_eticket(X),
        triple(X, identitas_valid, true),
        triple(X, surat_sehat_sesuai, true))).

aturan(r05_diizinkan, pendaki_diizinkan_memulai(X),
       (siap_bayar(X), memiliki_eticket(X), checkin_lengkap(X),
        triple(X, packin_lolos, true),
        triple(X, safety_briefing, true))).

aturan(r_test_negation, bebas_kemasan_terlarang(X),
       (triple(X, pendaki, true), \+ triple(X, membawa_kemasan_terlarang, true))).

aturan(r_test_numeric, rasio_guide_terpenuhi(X),
       (triple(X, jumlah_pendaki, N), N =< 4,
        triple(X, beban_guide_kg, W), W =< 15)).
