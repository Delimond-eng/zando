import 'dart:convert';

import 'package:zando/models/invoice.dart';
//import 'package:zando/models/user.dart';

import 'sqlite_db_helper.dart';

class DataManager {
  static Future<void> createTables() async {
    try {
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS users(user_id INTEGER NOT NULL PRIMARY KEY, user_name TEXT, user_role TEXT, user_pass TEXT, user_access TEXT)");
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS currency(currency_id INTEGER NOT NULL PRIMARY KEY, currency_value TEXT)");
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS clients(client_id INTEGER NOT NULL PRIMARY KEY, client_nom TEXT,client_tel TEXT, client_adresse TEXT, client_create_At INTEGER, client_state TEXT, user_id INTEGER)");
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS factures(facture_id INTEGER NOT NULL PRIMARY KEY, facture_montant REAL, facture_devise TEXT, facture_client_id INTEGER NOT NULL, facture_create_At INTEGER, facture_statut TEXT, facture_state TEXT, user_id INTEGER)");
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS facture_details(facture_detail_id INTEGER NOT NULL PRIMARY KEY, facture_detail_libelle TEXT, facture_detail_qte INTEGER, facture_detail_pu REAL, facture_detail_devise TEXT, facture_detail_create_At INTEGER,facture_detail_state TEXT, facture_id INTEGER)");
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS comptes(compte_id INTEGER NOT NULL PRIMARY KEY, compte_libelle TEXT, compte_devise TEXT,compte_status TEXT, compte_create_At INTEGER, compte_state TEXT)");
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS articles(article_id INTEGER NOT NULL PRIMARY KEY, article_libelle TEXT, article_create_At INTEGER, article_state TEXT)");
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS stocks(stock_id INTEGER NOT NULL PRIMARY KEY, stock_qte INTEGER, stock_prix_achat REAL, stock_prix_achat_devise TEXT,stock_article_id INTEGER, stock_status TEXT, stock_create_At INTEGER, stock_state TEXT)");
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS mouvements(mouvt_id INTEGER NOT NULL PRIMARY KEY, mouvt_qte INTEGER, mouvt_stock_id INTEGER, mouvt_create_At INTEGER, mouvt_state TEXT)");
      await DbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS operations(operation_id INTEGER NOT NULL PRIMARY KEY,operation_libelle TEXT,operation_type TEXT,operation_montant REAL, operation_devise TEXT, operation_compte_id INTEGER, operation_facture_id INTEGER, operation_mode TEXT, operation_user_id INTEGER, operation_create_At INTEGER, operation_state TEXT)");

      /*var checkedUsers = await DbHelper.query(table: "users");
      if (checkedUsers != null) {
        print("users checked !");
        if (checkedUsers.isEmpty) {
          var user = User(
            userName: "admin",
            userRole: "Administrateur",
            userPass: "12345",
          );
          var latestInsertedUserId =
              await DbHelper.insert(tableName: "users", values: user.toMap());
          if (latestInsertedUserId != null) {
            print("user created !");
          }
        }
      }*/
    } catch (e) {
      print("error from creating tables $e");
    }
  }

  static Future<Invoice> getFactureInvoice({int factureId}) async {
    var jsonResponse;
    try {
      var facture = await DbHelper.rawQuery(
          "SELECT * FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_id = '$factureId'");
      if (facture != null) {
        var details = await DbHelper.query(
          table: "facture_details",
          where: "facture_id",
          whereArgs: [factureId],
        );

        if (details != null) {
          jsonResponse = jsonEncode(
              {"facture": facture.first, "facture_details": details});
        }
      }
    } catch (ex) {
      print("error from $ex");
    }

    if (jsonResponse != null) {
      var invoice = Invoice.fromMap(jsonDecode(jsonResponse));
      return invoice;
    } else {
      return null;
    }
  }
}
