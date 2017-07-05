# -*- coding:utf-8 -*-
from sqlalchemy import *
from sqlalchemy.orm import *
from datetime import datetime

#echo true 表示输出sql语句
metadata = MetaData()
engine = create_engine('mysql://root:root@localhost/id_photo_local',echo=True)
#直接绑定 engine 的MetaData bound_meta = MetaData('sqlite:///test2.db')
metadata.bind = engine

#用户表
user_table = Table(
    'tf_user', metadata,#表名 tf_user
    Column('id', Integer, primary_key=True),
    Column('user_name', Unicode(16),unique=True, nullable=False),
    Column('password', Unicode(40), nullable=False),
    Column('display_name', Unicode(255), default=''),
    Column('created', DateTime, default=datetime.now)
)

metadata.create_all()

# Models
# from sqlalchemy.ext.declarative import declarative_base
# Base = declarative_base()
# class Actresses(Base):
#     __tablename__ = 'JA_NAME'
#     id = Column('id', Integer, primary_key=True, autoincrement=True)
#     name = Column('NAME_URL',String)
#     nameUrl = Column('NAME',String)
#
#
# class MovieInfo(Base):
#     __tablename__ = 'JA_MOVIE_INFO'
#     id = Column('id', Integer, primary_key=True, autoincrement=True)
#     art_name = Column('NAME',String)
#     img_url = Column('IMAGE_URL',String)
#     x_id = Column('FANHAO',String)
#     date = Column('RIQI',String)
#     time_length = Column('CHANGDU',String)
#     score = Column('PINFEN',String)
#     movie_title = Column('LEIBIE',String)




# from sqlalchemy.orm import sessionmaker
# from sqlalchemy.ext.declarative import declarative_base

# Base = declarative_base()
# Session = sessionmaker(bind=engine)
# session = Session()


# actList = session.query(Actresses)[90:100]
# movieList = session.query(MovieInfo).o
# for act in actList:
#     # print act.id
# for m in movieList:
#     print m.x_id

