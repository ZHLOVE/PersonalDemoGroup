# -*- coding:utf-8-*-
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from serializer import Serializer
import re
import logging
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                    filename='udeean.log',
                    filemode='a')

metadata = MetaData()

Base = declarative_base()

# +---------------------+
# | COLUMN_NAME         |
# +---------------------+
# | id                  |
# | order_id            |
# | createTime          |
# | print_num           |
# | price               |
# | is_print            |
# | consignee_name      |
# | consignee_phone     |
# | consignee_addr      |
# | origin_pic_name     |
# | final_pic_name      |
# | print_pic_name      |
# | spec_name           |
# | spec_id             |
# | serial_number       |
# | Ten_or_Ali_order_id |
# | payment_type        |
# | payment_state       |
# | subject             |
# | payment_time        |
# | fee                 |
# | channel             |
# +---------------------+

class Print_order(Base):
    __tablename__ = 'print_order'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    order_id = Column('order_id', String)
    createTime = Column('createTime', String)
    print_num = Column('print_num', Integer)
    price = Column('price', String)
    is_print = Column('is_print', Integer)
    consignee_name = Column('consignee_name', String)
    consignee_phone = Column('consignee_phone', String)
    consignee_addr = Column('consignee_addr', String)
    origin_pic_name = Column('origin_pic_name', String)
    final_pic_name = Column('final_pic_name', String)
    print_pic_name = Column('print_pic_name', String)
    spec_name = Column('spec_name', String)
    spec_id = Column('spec_id', Integer)
    serial_number = Column('serial_number', String)
    Ten_or_Ali_order_id = Column('Ten_or_Ali_order_id', String)
    payment_type = Column('payment_type', String)
    payment_state = Column('payment_state', Integer)
    subject = Column('subject', String)
    payment_time = Column('payment_time', String)
    fee = Column('fee', String)
    channel = Column('channel', String)

# +-------------------+-------------+------+-----+---------+----------------+
# | Field             | Type        | Null | Key | Default | Extra          |
# +-------------------+-------------+------+-----+---------+----------------+
# | spec_id           | int(11)     | NO   | PRI | NULL    | auto_increment |
# | name              | varchar(50) | YES  |     | NULL    |                |
# | head_length       | varchar(50) | YES  |     | NULL    |                |
# | head_occupy       | varchar(50) | YES  |     | NULL    |                |
# | eye_space         | varchar(50) | YES  |     | NULL    |                |
# | hairline_top      | varchar(50) | YES  |     | NULL    |                |
# | eyes_center_left  | varchar(50) | YES  |     | NULL    |                |
# | eyes_space_bottom | varchar(50) | YES  |     | NULL    |                |
# | shoulder_occupy   | varchar(50) | YES  |     | NULL    |                |
# | left_right_empty  | varchar(50) | YES  |     | NULL    |                |
# | facial_width      | varchar(50) | YES  |     | NULL    |                |
# | width_px          | varchar(50) | YES  |     | NULL    |                |
# | height_px         | varchar(50) | YES  |     | NULL    |                |
# | width_mm          | varchar(50) | YES  |     | NULL    |                |
# | height_mm         | varchar(50) | YES  |     | NULL    |                |
# | file_size_min     | varchar(50) | YES  |     | NULL    |                |
# | file_size_max     | varchar(50) | YES  |     | NULL    |                |
# | size_options      | varchar(50) | YES  |     | NULL    |                |
# | ppi               | varchar(50) | YES  |     | NULL    |                |
# | photo_format      | varchar(50) | YES  |     | NULL    |                |
# | bit_depth         | varchar(50) | YES  |     | NULL    |                |
# | compress          | varchar(50) | YES  |     | NULL    |                |
# | facial_pose       | varchar(50) | YES  |     | NULL    |                |
# | sight_line        | varchar(50) | YES  |     | NULL    |                |
# | facial_shelter    | varchar(50) | YES  |     | NULL    |                |
# | eyes_close        | varchar(50) | YES  |     | NULL    |                |
# | eyes_nature       | varchar(50) | YES  |     | NULL    |                |
# | mouse_nature      | varchar(50) | YES  |     | NULL    |                |
# | shoulder_equal    | varchar(50) | YES  |     | NULL    |                |
# | face_unbalance    | varchar(50) | YES  |     | NULL    |                |
# | glasses           | varchar(50) | YES  |     | NULL    |                |
# | glasses_glare     | varchar(50) | YES  |     | NULL    |                |
# | face_expression   | varchar(50) | YES  |     | NULL    |                |
# | face_center       | varchar(50) | YES  |     | NULL    |                |
# | face_color        | varchar(50) | YES  |     | NULL    |                |
# | face_blur         | varchar(50) | YES  |     | NULL    |                |
# | face_noise        | varchar(50) | YES  |     | NULL    |                |
# | face_over_kbt     | varchar(50) | YES  |     | NULL    |                |
# | bg_shadow         | varchar(50) | YES  |     | NULL    |                |
# | clothes_similar   | varchar(50) | YES  |     | NULL    |                |
# | background_color  | text        | YES  |     | NULL    |                |
# | chin_bottom       | varchar(50) | YES  |     | NULL    |                |
# +-------------------+-------------+------+-----+---------+----------------+

class Specs(Base):
    __tablename__ = 'Specs'
    spec_id = Column('spec_id', Integer, primary_key=True, autoincrement=True)
    name             = Column('name',String)
    head_length      = Column('head_length',String)
    head_occupy      = Column('head_occupy',String)
    eye_space        = Column('eye_space',String)
    hairline_top     = Column('hairline_top',String)
    eyes_center_left = Column('eyes_center_left',String)
    eyes_space_bottom= Column('eyes_space_bottom',String)
    shoulder_occupy  = Column('shoulder_occupy',String)
    left_right_empty = Column('left_right_empty',String)
    facial_width     = Column('facial_width',String)
    width_px         = Column('width_px',String)
    height_px        = Column('height_px',String)
    width_mm         = Column('width_mm',String)
    height_mm        = Column('height_mm',String)
    file_size_min    = Column('file_size_min',String)
    file_size_max    = Column('file_size_max',String)
    size_options     = Column('size_options',String)
    ppi              = Column('ppi',String)
    photo_format     = Column('photo_format',String)
    bit_depth        = Column('bit_depth',String)
    compress         = Column('compress',String)
    facial_pose      = Column('facial_pose',String)
    sight_line       = Column('sight_line',String)
    facial_shelter   = Column('facial_shelter',String)
    eyes_close       = Column('eyes_close',String)
    eyes_nature      = Column('eyes_nature',String)
    mouse_nature     = Column('mouse_nature',String)
    shoulder_equal   = Column('shoulder_equal',String)
    face_unbalance   = Column('face_unbalance',String)
    glasses          = Column('glasses',String)
    glasses_glare    = Column('glasses_glare',String)
    face_expression  = Column('face_expression',String)
    face_center      = Column('face_center',String)
    face_color       = Column('face_color',String)
    face_blur        = Column('face_blur',String)
    face_noise       = Column('face_noise',String)
    face_over_kbt    = Column('face_over_kbt',String)
    bg_shadow        = Column('bg_shadow',String)
    clothes_similar  = Column('clothes_similar',String)
    background_color = Column('background_color',String)
    chin_bottom      = Column('chin_bottom',String)

# +-------------------------+--------------+------+-----+---------+-------+
# | Field                   | Type         | Null | Key | Default | Extra |
# +-------------------------+--------------+------+-----+---------+-------+
# | spec_id                 | int(11)      | NO   | PRI | NULL    |       |
# | name                    | varchar(255) | YES  |     | NULL    |       |
# | head_length_max_p       | int(11)      | YES  |     | NULL    |       |
# | head_length_min_p       | int(11)      | YES  |     | NULL    |       |
# | head_occupy_max_p       | int(11)      | YES  |     | NULL    |       |
# | head_occupy_min_p       | int(11)      | YES  |     | NULL    |       |
# | eye_space_max_p         | int(11)      | YES  |     | NULL    |       |
# | eye_space_min_p         | int(11)      | YES  |     | NULL    |       |
# | hairline_top_max_p      | varchar(255) | YES  |     | NULL    |       |
# | hairline_top_min_p      | varchar(255) | YES  |     | NULL    |       |
# | eyes_center_left_max_p  | int(11)      | YES  |     | NULL    |       |
# | eyes_center_left_min_p  | int(11)      | YES  |     | NULL    |       |
# | eyes_space_bottom_max_p | int(11)      | YES  |     | NULL    |       |
# | eyes_space_bottom_min_p | int(11)      | YES  |     | NULL    |       |
# | shoulder_occupy         | int(11)      | YES  |     | NULL    |       |
# | left_right_empty        | int(11)      | YES  |     | NULL    |       |
# | facial_width_max_p      | int(11)      | YES  |     | NULL    |       |
# | facial_width_min_p      | int(11)      | YES  |     | NULL    |       |
# | width_px                | int(11)      | YES  |     | NULL    |       |
# | height_px               | int(11)      | YES  |     | NULL    |       |
# | width_mm                | int(11)      | YES  |     | NULL    |       |
# | height_mm               | int(11)      | YES  |     | NULL    |       |
# | file_size_max           | int(11)      | YES  |     | NULL    |       |
# | file_size_min           | int(11)      | YES  |     | NULL    |       |
# | size_options            | varchar(255) | YES  |     | NULL    |       |
# | ppi                     | int(11)      | YES  |     | NULL    |       |
# | photo_format            | varchar(20)  | YES  |     | NULL    |       |
# | bit_depth               | int(11)      | YES  |     | NULL    |       |
# | compress                | int(11)      | YES  |     | NULL    |       |
# | facial_pose             | int(11)      | YES  |     | NULL    |       |
# | sight_line              | int(11)      | YES  |     | NULL    |       |
# | facial_shelter          | int(11)      | YES  |     | NULL    |       |
# | eyes_close              | int(11)      | YES  |     | NULL    |       |
# | eyes_nature             | int(11)      | YES  |     | NULL    |       |
# | mouse_nature            | int(11)      | YES  |     | NULL    |       |
# | shoulder_equal          | int(11)      | YES  |     | NULL    |       |
# | face_unbalance          | int(11)      | YES  |     | NULL    |       |
# | glasses                 | int(11)      | YES  |     | NULL    |       |
# | glasses_glare           | int(11)      | YES  |     | NULL    |       |
# | face_expression         | int(11)      | YES  |     | NULL    |       |
# | face_center             | int(11)      | YES  |     | NULL    |       |
# | face_color              | int(11)      | YES  |     | NULL    |       |
# | face_blur               | int(11)      | YES  |     | NULL    |       |
# | face_noise              | int(11)      | YES  |     | NULL    |       |
# | face_over_kbt           | int(11)      | YES  |     | NULL    |       |
# | bg_shadow               | int(11)      | YES  |     | NULL    |       |
# | clothes_similar         | int(11)      | YES  |     | NULL    |       |
# | ratios                  | varchar(255) | YES  |     | NULL    |       |
# | background_color        | text         | YES  |     | NULL    |       |
# | chin_bottom_min_p       | int(11)      | YES  |     | NULL    |       |
# +-------------------------+--------------+------+-----+---------+-------+
class SpecsRule(Base):
    __tablename__ = 'Specs_rule'
    spec_id                 = Column('spec_id', Integer, primary_key=True, autoincrement=True)
    name                    = Column('name',String)
    head_length_max_p       = Column('head_length_max_p',Integer)
    head_length_min_p       = Column('head_length_min_p',Integer)
    head_occupy_max_p       = Column('head_occupy_max_p',Integer)
    head_occupy_min_p       = Column('head_occupy_min_p',Integer)
    eye_space_max_p         = Column('eye_space_max_p',Integer)
    eye_space_min_p         = Column('eye_space_min_p',Integer)
    hairline_top_max_p      = Column('hairline_top_max_p',String)
    hairline_top_min_p      = Column('hairline_top_min_p',String)
    eyes_center_left_max_p  = Column('eyes_center_left_max_p',Integer)
    eyes_center_left_min_p  = Column('eyes_center_left_min_p',Integer)
    eyes_space_bottom_max_p = Column('eyes_space_bottom_max_p',Integer)
    eyes_space_bottom_min_p = Column('eyes_space_bottom_min_p',Integer)
    shoulder_occupy         = Column('shoulder_occupy',Integer)
    left_right_empty        = Column('left_right_empty',Integer)
    facial_width_max_p      = Column('facial_width_max_p',Integer)
    facial_width_min_p      = Column('facial_width_min_p',Integer)
    width_px                = Column('width_px',Integer)
    height_px               = Column('height_px',Integer)
    width_mm                = Column('width_mm',Integer)
    height_mm               = Column('height_mm',Integer)
    file_size_max           = Column('file_size_max',Integer)
    file_size_min           = Column('file_size_min',Integer)
    size_options            = Column('size_options',String)
    ppi                     = Column('ppi',Integer)
    photo_format            = Column('photo_format',String)
    bit_depth               = Column('bit_depth',Integer)
    compress                = Column('compress',Integer)
    facial_pose             = Column('facial_pose',Integer)
    sight_line              = Column('sight_line',Integer)
    facial_shelter          = Column('facial_shelter',Integer)
    eyes_close              = Column('eyes_close',Integer)
    eyes_nature             = Column('eyes_nature',Integer)
    mouse_nature            = Column('mouse_nature',Integer)
    shoulder_equal          = Column('shoulder_equal',Integer)
    face_unbalance          = Column('face_unbalance',Integer)
    glasses                 = Column('glasses',Integer)
    glasses_glare           = Column('glasses_glare',Integer)
    face_expression         = Column('face_expression',Integer)
    face_center             = Column('face_center',Integer)
    face_color              = Column('face_color',Integer)
    face_blur               = Column('face_blur',Integer)
    face_noise              = Column('face_noise',Integer)
    face_over_kbt           = Column('face_over_kbt',Integer)
    bg_shadow               = Column('bg_shadow',Integer)
    clothes_similar         = Column('clothes_similar',Integer)
    ratios                  = Column('ratios',String)
    background_color        = Column('background_color',String)
    chin_bottom_min_p       = Column('chin_bottom_min_p',Integer)

# +----------+---------+--------+-------+-----------+----------------+
# | Field    | Type    | Null   | Key   |   Default | Extra          |
# |----------+---------+--------+-------+-----------+----------------|
# | id       | int(11) | NO     | PRI   |    <null> | auto_increment |
# | is_audit | int(11) | YES    |       |    <null> |                |
# +----------+---------+--------+-------+-----------+----------------+
class IsAudit(Base):
    __tablename__ = 'audit'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    is_audit = Column('is_audit',Integer)

# +----------+---------+--------+-------+-----------+----------------+
# | Field    | Type    | Null   | Key   |   Default | Extra          |
# |----------+---------+--------+-------+-----------+----------------|
# | id       | int(11) | NO     | PRI   |    <null> | auto_increment |
# | is_audit | int(11) | YES    |       |    <null> |                |
# +----------+---------+--------+-------+-----------+----------------+
class IsAuditPro(Base):
    __tablename__ = 'audit_professional'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    is_audit = Column('is_audit',Integer)

# +----------------+---------+--------+-------+-----------+---------+
# | Field          | Type    | Null   | Key   |   Default | Extra   |
# |----------------+---------+--------+-------+-----------+---------|
# | id             | int(11) | NO     | PRI   |    <null> |         |
# | control_status | int(11) | YES    |       |    <null> |         |
# +----------------+---------+--------+-------+-----------+---------+
class MomentsControl(Base):
    __tablename__ = 'moments_control'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    control_status = Column('control_status',Integer)

# +----------------+---------+--------+-------+-----------+---------+
# | Field          | Type    | Null   | Key   |   Default | Extra   |
# |----------------+---------+--------+-------+-----------+---------|
# | id             | int(11) | NO     | PRI   |    <null> |         |
# | control_status | int(11) | YES    |       |    <null> |         |
# +----------------+---------+--------+-------+-----------+---------+
class MomentsControlAndroid(Base):
    __tablename__ = 'moments_control_android'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    control_status = Column('control_status',Integer)


class LeQiMySQL(object):
    def __init__(self):
        self.dbPath = 'mysql://root:root@139.196.52.216:3306/leqi?charset=utf8'
        self.engine = create_engine(self.dbPath, encoding='utf-8', echo=True)
        self.DB_Session = sessionmaker(bind=self.engine)
        self.session = self.DB_Session()
        print 'LeQiMySQl init finish'

    # 根据手机号查
    def searchPrintOrderWithPhoneNumber(self, phoneNum):
        pattern = re.compile(r"0?(13|14|15|16|17|18)[0-9]{9}")
        phone_str = pattern.match(phoneNum)
        if phone_str:
            try:
                printOrlerList = self.session.query(Print_order).filter(Print_order.consignee_phone == phoneNum).all()
                serializer = Serializer(printOrlerList, many=True)
                result = serializer.data
            except:
                self.session.rollback()
            self.session.close()
            return result

        else:
            phone_str = '请输入正确的号码'
            return phone_str
    # 根据订单号查
    def searchPrintOrderWithSerialNumber(self, serialNum):
        return 'searchFinash'

    # 增加规格
    def appSpec(self,dataDict):
        specDict = dataDict['specData']
        specRuleDict = dataDict['specRuleData']
        spec = Specs()
        specRule = SpecsRule()
        for key,value in specDict.items():
            if key != 'spec_id':
                setattr(spec,key,value)

        for key,value in specRuleDict.items():
            print key
            print value
            if key != 'spec_id':
                setattr(specRule,key,value)
                if value == '':
                    setattr(specRule,key,None)


        print spec.name
        print specRule.name
        self.session.add(spec)
        self.session.add(specRule)
        try:
            self.session.commit()
        except:
            self.session.rollback()
        self.session.close()


    # 删除规格
    def deleteSpec(self,spec_id):
        print 'deleteSpec:' + spec_id
        self.session.execute("delete from Specs where spec_id = " + spec_id + ";")
        self.session.execute("delete from Specs_rule where spec_id = " + spec_id + ";")
        try:
            self.session.commit()
        except:
            self.session.rollback()
        self.session.close()


    # 查询审核开关状态
    def getAudit(self):
        try:
            status = self.session.query(IsAudit).filter(IsAudit.id == 1).all()
            status_maJia = self.session.query(IsAuditPro).filter(IsAuditPro.id == 1).all()
            moments_control = self.session.query(MomentsControl).filter(MomentsControl.id == 1).all()
            moments_control_android = self.session.query(MomentsControlAndroid).filter(MomentsControlAndroid.id == 1).all()
            statusResult = Serializer(status, many=True).data
            statusPro = Serializer(status_maJia, many=True).data
            s_mc = Serializer(moments_control, many=True).data
            s_mca = Serializer(moments_control_android, many=True).data
            # iOS分享开关
            iOSShareSwitch = s_mc[0]['control_status']
            # 安卓分享开关
            androidShareSwitch = s_mca[0]['control_status']
            # iOS审核开关
            iOSReviewSwitch = statusResult[0]['is_audit']
            # iOS马甲包审核开关
            iOSMaJiaReviewSwitch = statusPro[0]['is_audit']
            allStatus = {
                'isAudit':iOSReviewSwitch,
                'iOSMaJiaAudit':iOSMaJiaReviewSwitch,
                'iOSShare':iOSShareSwitch,
                'androidShare':androidShareSwitch
            }
            # print allStatus
        except:
            self.session.rollback()
        self.session.close()
        return allStatus

    # 设置审核开关
    def setAudit(self,auditArgs):
        print auditArgs
        if auditArgs.has_key('iOS_review'):
            iOSReview = auditArgs['iOS_review']
            self.session.execute("UPDATE `audit` SET is_audit = "+ iOSReview + " WHERE id = 1;")
        if auditArgs.has_key('iOS_majia'):
            iOSMaJia = auditArgs['iOS_majia']
            self.session.execute("UPDATE `audit_professional` SET is_audit = "+ iOSMaJia + " WHERE id = 1;")
        if auditArgs.has_key('iOS_share_set'):
            iOSShare = auditArgs['iOS_share_set']
            self.session.execute("UPDATE `moments_control` SET control_status = "+ iOSShare + " WHERE id = 1;")
        if auditArgs.has_key('android_share_set'):
            androidShare = auditArgs['android_share_set']
            self.session.execute("UPDATE `moments_control_android` SET control_status = "+ androidShare + " WHERE id = 1;")

        try:
            self.session.commit()
        except:
            self.session.rollback()
        self.session.close()

















# end
