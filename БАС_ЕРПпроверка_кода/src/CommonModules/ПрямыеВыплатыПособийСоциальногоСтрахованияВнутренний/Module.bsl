#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьПризнакВыплачиваетсяФСССуществующихДокументов(МенеджерВременныхТаблиц) Экспорт
	
	ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ЗаполнитьПризнакВыплачиваетсяФСССуществующихДокументов(МенеджерВременныхТаблиц);
	
КонецПроцедуры

Функция КатегорииНачисленийПособийПоПрямымВыплатамФСС() Экспорт
		
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.КатегорииНачисленийПособийПоПрямымВыплатамФСС();	
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаявлениеРасчетВФСС

Функция ДанныеЗаполненияЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов(Месяц, ФондСоциальногоСтрахования, Организация, СписокСотрудников, Ссылка, ОплатаДнейУходаЗаДетьмиИнвалидами = Неопределено) Экспорт
	 Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ДанныеЗаполненияЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов(Месяц, ФондСоциальногоСтрахования, Организация, СписокСотрудников, Ссылка, ОплатаДнейУходаЗаДетьмиИнвалидами);
КонецФункции 

Функция ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов();
	
КонецФункции 

Функция ИспользуетсяЗаполнениеДокументаЗаявлениеРасчетВФСС() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ИспользуетсяЗаполнениеДокументаЗаявлениеРасчетВФСС();
	
КонецФункции 

#КонецОбласти

Функция ДанныеЗаполненияРасходовНаПогребение(Месяц, ФондСоциальногоСтрахования, Организация, СписокСотрудников, Ссылка, ЕдиновременноеПособие = Неопределено) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ДанныеЗаполненияРасходовНаПогребение(Месяц, ФондСоциальногоСтрахования, Организация, СписокСотрудников, Ссылка, ЕдиновременноеПособие);
	
КонецФункции 


#КонецОбласти
