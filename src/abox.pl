% triple(Subjek, Predikat, Objek)
:- dynamic triple/3.

% Calon pendaki
triple(calon_a, rdf_type, pendaki).
triple(calon_a, memiliki_e_tiket, e_tiket_calon_a).
triple(calon_a, barang_kemasan_terlarang, false).
triple(calon_a, check_in_terverifikasi, true).
triple(calon_a, identitas_berlaku, true).
triple(calon_a, perlengkapan_sesuai_checklist, true).
triple(calon_a, safety_briefing_diikuti, true).
triple(calon_a, surat_sehat_h_min_1, true).
triple(calon_a, wadah_guna_ulang, true).

triple(calon_b, rdf_type, pendaki).
triple(calon_b, barang_kemasan_terlarang, false).
triple(calon_b, check_in_terverifikasi, true).
triple(calon_b, identitas_berlaku, true).
triple(calon_b, perlengkapan_sesuai_checklist, true).
triple(calon_b, safety_briefing_diikuti, true).
triple(calon_b, surat_sehat_h_min_1, false).
triple(calon_b, wadah_guna_ulang, true).

% E-Tiket
triple(e_tiket_calon_a, rdf_type, e_tiket).
triple(e_tiket_calon_b, rdf_type, e_tiket).

% Guide
triple(guide1, rdf_type, guide).
triple(guide1, bekerja_pada, t_o1).
triple(guide1, beban_kg, 15).

triple(guide2, rdf_type, guide).
triple(guide2, memiliki_asuransi, asuransi_standar1).

% Kelompok
triple(kelompok1, rdf_type, kelompok).
triple(kelompok1, beranggota, pendaki8).
triple(kelompok1, beranggota, pendaki9).
triple(kelompok1, beranggota, pendaki_e).

triple(kelompok_c, rdf_type, kelompok).
triple(kelompok_c, beranggota, pendaki_c).

% Trekking Organizer
triple(t_o1, rdf_type, trekking_organizer).

% Asuransi
triple(asuransi_premium1, rdf_type, asuransi_premium).
triple(asuransi_standar1, rdf_type, asuransi_standar).

% Pendaki
triple(pendaki1, rdf_type, pendaki).
triple(pendaki1, didampingi_oleh, guide1).

triple(pendaki2, rdf_type, pendaki).
triple(pendaki2, didampingi_oleh, guide1).

triple(pendaki3, rdf_type, pendaki).
triple(pendaki3, didampingi_oleh, guide1).

triple(pendaki4, rdf_type, pendaki).
triple(pendaki4, didampingi_oleh, guide1).

triple(pendaki5, rdf_type, pendaki).
triple(pendaki5, didampingi_oleh, guide1).

triple(pendaki6, rdf_type, pendaki).
triple(pendaki6, memiliki_asuransi, asuransi_premium1).

triple(pendaki7, rdf_type, pendaki).
triple(pendaki7, memiliki_asuransi, asuransi_standar1).

triple(pendaki8, rdf_type, pendaki).
triple(pendaki8, rdf_type, pendaki_berpengalaman).
triple(pendaki8, usia, 20).

triple(pendaki9, rdf_type, pendaki).

triple(pendaki10, rdf_type, pendaki).
triple(pendaki10, usia, 16).

triple(pendaki11, rdf_type, pendaki).

triple(pendaki_c, rdf_type, pendaki).

triple(pendaki_d, rdf_type, pendaki).
triple(pendaki_d, rdf_type, pendaki_mancanegara).

triple(pendaki_e, rdf_type, pendaki).
triple(pendaki_e, didampingi_oleh, pendaki8).
triple(pendaki_e, izin_orang_tua_diserahkan, true).
triple(pendaki_e, usia, 16).

triple(pendaki_f, rdf_type, pendaki).
triple(pendaki_f, durasi_hari_overtime, 4).

triple(pendaki_g, rdf_type, pendaki).
triple(pendaki_g, durasi_hari_overtime, 4).

triple(pendaki_h, rdf_type, pendaki).
triple(pendaki_h, jalur_sesuai_e_tiket, false).
triple(pendaki_h, pemberitahuan_bersyarat_dipenuhi, false).
triple(pendaki_h, pendakian_khusus, false).

triple(pendaki_i, rdf_type, pendaki).
triple(pendaki_i, check_out_dilakukan, true).
triple(pendaki_i, durasi_sesuai_tiket, true).
triple(pendaki_i, pack_out_dilakukan, true).
triple(pendaki_i, sampah_pilahan_diserahkan, false).

triple(pendaki_j, rdf_type, pendaki).
triple(pendaki_j, dibatalkan_mendaki_karena, penutupan_insidental1).

% Penyedia Makanan Minuman
triple(penyedia1, rdf_type, penyedia_makanan_minuman).
triple(penyedia1, persen_produk_lokal, 10).

% Aktivitas Memancing
triple(aktivitas_memancing1, rdf_type, aktivitas_pada_satwa).
triple(aktivitas_memancing1, memancing_di_tepi_danau_segara_anak, true).
triple(aktivitas_memancing1, tindakan_satwa_umum, false).

% Pelanggaran
triple(pelanggaran1, rdf_type, pelanggaran).
triple(pelanggaran1, nomor_aturan, 27).
triple(pelanggaran2, rdf_type, pelanggaran).
triple(pelanggaran2, nomor_aturan, 28).
triple(pelanggaran3, rdf_type, pelanggaran).
triple(pelanggaran3, nomor_aturan, 29).
triple(pelanggaran4, rdf_type, pelanggaran).
triple(pelanggaran4, nomor_aturan, 25).
triple(pelanggaran5, rdf_type, pelanggaran).
triple(pelanggaran5, nomor_aturan, 26).

% Penutupan Insidental (refund)
triple(penutupan_insidental1, rdf_type, penutupan_insidental).






