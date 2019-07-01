////////////////////////////////////////////////////////////////////////////////
// ФизическиеЛицаЗарплатаКадрыВнутренний: методы, дополняющие функциональность
// 		 справочника ФизическиеЛица.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПроверитьДанныеФизическогоЛица(ДанныеФизическогоЛица, ПравилаПроверки, Ошибки, Отказ, НомерСтроки) Экспорт
	
	ФизическиеЛицаЗарплатаКадрыБазовый.ПроверитьДанныеФизическогоЛица(ДанныеФизическогоЛица, ПравилаПроверки, Ошибки, Отказ, НомерСтроки);
	
КонецПроцедуры
		
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	ФизическиеЛицаЗарплатаКадрыРасширенный.ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	ФизическиеЛицаЗарплатаКадрыРасширенный.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

Процедура ФормаВыбораСотрудниковПриСозданииНаСервере(Форма, Параметры) Экспорт
	
	ФизическиеЛицаЗарплатаКадрыРасширенный.ФормаВыбораСотрудниковПриСозданииНаСервере(Форма, Параметры);
	
КонецПроцедуры

#КонецОбласти
