# -*- coding:utf-8 -*-
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

from sqlalchemy import Column, Integer, String
class User(Base):
    __tablename__ = 'users'

    id = Column(Integer,primary_key = True)
    name = Column(String)
    className = Column(String)
    
