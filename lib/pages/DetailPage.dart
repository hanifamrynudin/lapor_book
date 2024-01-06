import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapor_book/components/status_dialog.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/vars.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:lapor_book/models/laporan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DetailPage extends StatefulWidget {
    const DetailPage({super.key});
    @override
    State<StatefulWidget> createState() => _DetailPageState();
  }

  class _DetailPageState extends State<DetailPage> {
    bool _isLoading = false;
    bool isLiked = false;
    int likeCount = 0;
    
    Future launch(String uri) async {
      if (uri == '') return;
      if (!await launchUrl(Uri.parse(uri))) {
        throw Exception('Tidak dapat memanggil : $uri');
      }
    }

   void handleLikeButton() {
      setState(() {
        if (!isLiked) {
          likeCount += 1;
          isLiked = true;
          saveLikeToFirestore();
          // TODO: Simpan data like ke Firestore jika diperlukan
        }
      });
    }

    Future<void> saveLikeToFirestore() async {

      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      Laporan laporan = arguments['laporan'];
      Akun akun = arguments['akun'];

      try {
        final _firestore = FirebaseFirestore.instance;
        final laporanId = laporan.docId;
        final userId = laporan.uid;

        // Check if the user has already liked the post
        if (!laporan.likes!.contains(userId)) {
          // Update Firestore document with the new like
          await _firestore.collection('laporan').doc(laporanId).update({
            'likeCount': FieldValue.increment(1),
            'likes': FieldValue.arrayUnion([userId]),
          });

          // Update the local 'likes' array
          setState(() {
            laporan.likes!.add(userId);
          });

          // Catat bahwa like telah disimpan di Firestore
          print('Like berhasil disimpan di Firestore');
        } else {
          print('User already liked this post');
        }
      } catch (e) {
        // Tangani kesalahan jika ada
        print('Error saving like to Firestore: $e');
      }
    }


    String? status;

    void statusDialog(Laporan laporan) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatusDialog(
            laporan: laporan,
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      Laporan laporan = arguments['laporan'];
      Akun akun = arguments['akun'];

      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title:
              Text('Detail Laporan', style: headerStyle(level: 3, dark: false)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          laporan.judul,
                          style: headerStyle(level:3),
                        ),
                        const SizedBox(height: 15),
                        laporan.gambar != ''
                            ? Image.network(laporan.gambar!)
                            : Image.asset('assets/istock-default.jpg'),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            laporan.status == 'Posted'
                                ? textStatus(
                                    'Posted', Colors.yellow, Colors.black)
                                : laporan.status == 'Process'
                                    ? textStatus(
                                        'Process', Colors.green, Colors.white)
                                    : textStatus(
                                        'Done', Colors.blue, Colors.white),
                            textStatus(
                                laporan.instansi, Colors.white, Colors.black),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Center(child: Text('Nama Pelapor')),
                          subtitle: Center(
                            child: Text(laporan.nama),
                          ),
                          trailing: const SizedBox(width: 45),
                        ),
                        ListTile(
                          leading: const Icon(Icons.date_range),
                          title: const Center(child: Text('Tanggal Laporan')),
                          subtitle: Center(
                              child: Text(DateFormat('dd MMMM yyyy')
                                  .format(laporan.tanggal))),
                          trailing: IconButton(
                            icon: const Icon(Icons.location_on),
                            onPressed: () {
                              launch(laporan.maps);
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          'Deskripsi Laporan',
                          style: headerStyle(level:3),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(laporan.deskripsi ?? ''),
                        ),

      // Tombol Like
      Container(
  width: 250,
  child: isLiked
      ? Text('You already liked this post')  // Display a message
      : ElevatedButton(
          onPressed: () {
            handleLikeButton();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(isLiked ? 'Liked' : 'Like'),
        ),
),
              // Widget Jumlah Like
              Text(laporan.likeCount.toString()),

                        if (akun.role == 'admin')
      Container(
        width: 250,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              status = laporan.status;
            });
            statusDialog(laporan);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text('Ubah Status'),
        ),
      ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    }

    Container textStatus(String text, var bgcolor, var textcolor) {
      return Container(
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgcolor,
            border: Border.all(width: 1, color: primaryColor),
            borderRadius: BorderRadius.circular(25)),
        child: Text(
          text,
          style: TextStyle(color: textcolor),
        ),
      );
    }
  }