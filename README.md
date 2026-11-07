# Milestone 1 Part 2 Tugas Besar IF4070 RPP - Aturan Pendakian Gunung Rinjani K05

Implementasi program Prolog dari  Milestone 1 Part 2 IF4070 Representasi Pengetahuan dan Penalaran 
yang menerjemahkan ontologi domain Aturan Pendakian Gunung Rinjani ke Prolog (SWI-Prolog). 
Individu ditulis sebagai
"triple(Subjek, Predikat, Objek)" di abox.pl, sedangkan aturan domain r01 sampai r22
ditulis dengan ID di kb.pl bersama meta-interpreter yang menghasilkan penjelasan.

Antarmuka yang disediakan (dari kb.pl):

- classify(Individu, Kelas) : mengklasifikasikan individu pada kelas, bernilai true (terbukti) atau false 
- explain(classify(Individu, Kelas), Bukti) : menampilkan bukti untuk klasifikasi yang berhasil dalam format tree.
- why_not(classify(Individu, Kelas), Alasan) : menghasilkan daftar gagal(IdAturan, TujuanGagal)
  untuk klasifikasi yang gagal.

## Cara Menjalankan

Pada direktori src, load sistem secara lengkap beserta individu nya dari abox.pl dengan seperti berikut:

```sh
swipl main.pl
```

Untuk load sistem tanpa individu (hanya kb.pl), jalankan seperti berikut:

```sh
swipl kb.pl
```


## Contoh Kueri (dan hasilnya)

Mengeksekusi kueri predikat untuk classify(klasifikasi individu), explain(menjelaskan bukti klasifikasi berhasil),
why_not(menampilkan daftar gagal dari klasifikasi yang gagal),
contoh dengan individu dari abox.pl yang sudah di-load pada main.pl:

```prolog
?- classify(pendaki_e, pendaki_anak_memenuhi_syarat).
true.

?- explain(classify(pendaki_e, pendaki_anak_memenuhi_syarat), Bukti).
Bukti = bukti(r10, pendaki_anak_memenuhi_syarat(pendaki_e), [bukti(r10, pendaki_anak(pendaki_e), [fakta(pendaki(pendaki_e)), fakta(triple(pendaki_e, usia, 16)), fakta(16<17)]), bukti(inv_didampingi_oleh, didampingi_oleh(pendaki_e, pendaki8), [fakta(triple(pendaki_e, didampingi_oleh, pendaki8))]), fakta(pendaki_berpengalaman(pendaki8)), fakta(triple(pendaki8, usia, 20)), fakta(20>17), fakta(triple(pendaki_e, izin_orang_tua_diserahkan, true))]).

?- classify(pendaki_i, pendaki_check_out_lengkap).
false.

?- why_not(classify(pendaki_i, pendaki_check_out_lengkap), Alasan).
Alasan = [gagal(r13, triple(pendaki_i, sampah_pilahan_diserahkan, true))].
```

Menambah individu di luar abox.pl sebelum melakukan kueri predikat:

```prolog
?- assertz(triple(pendaki_baru1, rdf_type, pendaki)).
true.

?- assertz(triple(pendaki_baru1, dibatalkan_mendaki_karena, gangguan_server_09)).
true.

?- assertz(triple(gangguan_server_09, rdf_type, gangguan_sistem)).
true.

?- classify(pendaki_baru1, pendaki_mendapat_refund).
true.
```

## Video Penjelasan

Link Google Drive: https://drive.google.com/file/d/1GGHRISpZwvPuUn6HPYpFqouQrXIZ_obu/view?usp=sharing
