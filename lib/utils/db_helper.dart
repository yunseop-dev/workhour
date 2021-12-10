import 'package:flutter_workhour/models/workhour.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableName = 'workhour';

class DBHelper {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'database.db'),
      // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, dayOfWeek INTEGER, startedAt INTEGER, endedAt INTEGER)",
        );
      },
      // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
      // 수행하기 위한 경로를 제공합니다.
      version: 1,
    );
    return _db;
  }

  Future<void> insertWorkhour(Workhour workhour) async {
    final db = await database;

    // Workhour를 올바른 테이블에 추가하세요. 또한
    // `conflictAlgorithm`을 명시할 것입니다. 본 예제에서는
    // 만약 동일한 workhour가 여러번 추가되면, 이전 데이터를 덮어쓸 것입니다.
    await db.insert(
      tableName,
      workhour.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Workhour>> workhours() async {
    final db = await database;

    // 모든 Workhour를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> maps = await db.query('workhours');

    // List<Map<String, dynamic>를 List<Workhour>으로 변환합니다.
    return List.generate(maps.length, (i) {
      return Workhour(
        id: maps[i]['id'],
        dayOfWeek: maps[i]['dayOfWeek'],
        startedAt: maps[i]['startedAt'],
        endedAt: maps[i]['endedAt'],
      );
    });
  }

  Future<void> updateWorkhour(Workhour workhour) async {
    final db = await database;

    // 주어진 Workhour를 수정합니다.
    await db.update(
      tableName,
      workhour.toMap(),
      // Workhour의 id가 일치하는 지 확인합니다.
      where: "dayOfWeek = ?",
      // Workhour의 id를 whereArg로 넘겨 SQL injection을 방지합니다.
      whereArgs: [workhour.dayOfWeek],
    );
  }

  Future<void> deleteWorkhour(int id) async {
    final db = await database;

    // 데이터베이스에서 Workhour를 삭제합니다.
    await db.delete(
      tableName,
      // 특정 workhour를 제거하기 위해 `where` 절을 사용하세요
      where: "id = ?",
      // Workhour의 id를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [id],
    );
  }
}
