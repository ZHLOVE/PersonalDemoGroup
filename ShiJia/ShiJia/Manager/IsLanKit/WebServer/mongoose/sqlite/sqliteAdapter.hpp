//
//  sqliteTest.hpp
//  sqliteTest
//
//  Created by Jian Huang on 21/03/2017.
//  Copyright © 2017 Jian Huang. All rights reserved.
//


#if !defined(sqliteTest_h)
#define sqliteTest_h


#include <stdio.h>
#include "sqlite3.h"
#include <string>
#include <boost/lexical_cast.hpp>
#include <vector>
#include <iostream>
#include <boost/tuple/tuple.hpp>
#if defined(ANDROID) || defined(__ANDROID__)
#include "logger/ystRWMutex.h"
#else
#include "ystRWMutex.h"
#endif
ystRWMutex g_Mutex;

static std::vector<boost::tuple<unsigned long, int, std::string, int> > selVec;

static int callback(void *NotUsed, int argc, char **argv, char **azColName){

    if (argc == 4 ) {
        selVec.push_back(boost::make_tuple(boost::lexical_cast<unsigned long>(argv[0]), boost::lexical_cast<int>(argv[1]), argv[2], boost::lexical_cast<int>(argv[3])));
    }
    return 0;
    
}

static unsigned int DB_Row = 0;

static int countCallback(void *NotUsed, int argc, char **argv, char **azColName){
    
    if (argc == 1) {
        DB_Row = boost::lexical_cast<unsigned int>(argv[0]);
    }
    
    return 0;
    
}


int DB_insert(std::string logData, int type/*0:立即 1:可缓冲*/, int state = 0/* 1:uploadAddr not valid, 2: user id is not valid, 3: network is not valid.*/){
    g_Mutex.wLock();
    sqlite3 *db;
    char *zErrMsg = 0;
    
    int rc;
    
    rc = sqlite3_open(getenv("YST_DATABASE_PATH"), &db);
    if( rc ) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return (-1);
    }
    rc = sqlite3_exec(db, "CREATE TABLE if not exists LOG_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, logData NTEXT, type int, state int);", callback, 0, &zErrMsg);
    
    if( rc!=SQLITE_OK ){
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return (-1);
    }
    
    std::string sql = "select COUNT(ID) from LOG_TABLE;";
    rc = sqlite3_exec(db, sql.c_str(), countCallback, 0, &zErrMsg);
    
    if( rc != SQLITE_OK ) {
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return (-1);
    } else {
        
        LOGD("\n---------------> DB_Row : %d\n", DB_Row);
        if (DB_Row > 5000) {
            fprintf(stderr, "SQL error: %s\n", "DB count reach max value 5000.");
            
            sqlite3_close(db);
            g_Mutex.wUnlock();
            return (-1);
        }
    }
    
    std::string typeStr = boost::lexical_cast<std::string>(type);
    std::string stateStr = boost::lexical_cast<std::string>(state);
    
    sql = "INSERT INTO LOG_TABLE (logData,type,state) VALUES ('" + logData + "', " + typeStr + ", " + stateStr + ");";
    rc = sqlite3_exec(db, sql.c_str(), callback, 0, &zErrMsg);
    
    if( rc != SQLITE_OK ) {
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return (-1);
    }
    
    sqlite3_close(db);
    g_Mutex.wUnlock();
    return 0;
}


std::vector<boost::tuple<unsigned long, int, std::string, int> >& DB_select() {
    g_Mutex.wLock();
    sqlite3 *db;
    char *zErrMsg = 0;
    
    int rc;
    
    selVec.clear();
    const char* path = getenv("YST_DATABASE_PATH");
    
    rc = sqlite3_open(path, &db);
    if( rc ) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return selVec;
    }
    rc = sqlite3_exec(db, "CREATE TABLE if not exists LOG_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, logData NTEXT, type int, state int);", callback, 0, &zErrMsg);
    
    if( rc!=SQLITE_OK ){
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return selVec;
    }
    
    
    std::string sql = "SELECT ID,type,logData,state from LOG_TABLE Order by ID Desc limit 50;";
    rc = sqlite3_exec(db, sql.c_str(), callback, 0, &zErrMsg);
    
    if( rc != SQLITE_OK ) {
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
        sqlite3_close(db);
        g_Mutex.wUnlock();
    } else {
    
        for (std::vector<boost::tuple<unsigned long, int, std::string, int> >::iterator iter = selVec.begin(); iter != selVec.end(); iter ++) {
            std::cout << "first : " << boost::get<0>(*iter) << " second : " << boost::get<1>(*iter) << " third: "<< boost::get<2>(*iter)<< " fourth: "<< boost::get<3>(*iter)<< "\n";
            
        }
    }
    g_Mutex.wUnlock();
    return selVec;
}

void DB_deleteItem(unsigned long index) {
    g_Mutex.wLock();
    sqlite3 *db;
    char *zErrMsg = 0;
    
    int rc;
    
    rc = sqlite3_open(getenv("YST_DATABASE_PATH"), &db);
    if( rc ) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return ;
    }
    rc = sqlite3_exec(db, "CREATE TABLE if not exists LOG_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, logData NTEXT, type int, state int);", callback, 0, &zErrMsg);
    
    if( rc!=SQLITE_OK ){
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return;
    }
    
    
    std::string sql = "delete from LOG_TABLE where ID = ";
    sql += boost::lexical_cast<std::string>(index) + ";";
    
    rc = sqlite3_exec(db, sql.c_str(), callback, 0, &zErrMsg);
    
    if( rc != SQLITE_OK ) {
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
        sqlite3_close(db);
    } else {
        printf("%s", (std::string("\nID = ") + boost::lexical_cast<std::string>(index) +  " deleted.\n").c_str());
    }
    g_Mutex.wUnlock();
}

void DB_clearDB() {
    g_Mutex.wLock();
    sqlite3 *db;
    char *zErrMsg = 0;
    
    int rc;
    
    rc = sqlite3_open(getenv("YST_DATABASE_PATH"), &db);
    if( rc ) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return ;
    }
    rc = sqlite3_exec(db, "CREATE TABLE if not exists LOG_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, logData NTEXT, type int, state int);", callback, 0, &zErrMsg);
    
    if( rc!=SQLITE_OK ){
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
        sqlite3_close(db);
        g_Mutex.wUnlock();
        return;
    }
    
    
    std::string sql = "DROP TABLE LOG_TABLE;";
    rc = sqlite3_exec(db, sql.c_str(), callback, 0, &zErrMsg);
    
    if( rc != SQLITE_OK ) {
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
    } else {
        printf("\nTABLE LOG_TABLE Dropped.\n");
    }
    g_Mutex.wUnlock();
}


#endif /* sqliteTest_h */
