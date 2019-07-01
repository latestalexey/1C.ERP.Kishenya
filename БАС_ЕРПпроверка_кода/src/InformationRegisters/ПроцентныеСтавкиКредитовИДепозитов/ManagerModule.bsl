#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаписатьПроцентнуюСтавкуКомисиию(Договор, НоваяСтавка, НоваяКомиссия, Период = Неопределено) Экспорт
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Договор.Установить(Договор);
	НаборЗаписей.Прочитать();	
	Если НаборЗаписей.Количество() <= 1 Тогда
		ИсторияСтавок = НаборЗаписей.Выгрузить();
		Если ИсторияСтавок.Количество() = 0 Тогда
			СтрокаДанных = ИсторияСтавок.Добавить();
		Иначе
			СтрокаДанных = ИсторияСтавок[0];
		КонецЕсли;
		СтрокаДанных.Период		= Договор.Дата;
		СтрокаДанных.Договор	= Договор.Ссылка;
		СтрокаДанных.Процент	= НоваяСтавка;
		СтрокаДанных.Комиссия	= НоваяКомиссия;
		НаборЗаписей.Загрузить(ИсторияСтавок);
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьИстория(Договор) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Договор.Установить(Договор);
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей.Количество() > 1;
	
КонецФункции

Процедура ПрочитатьПроцентнуюСтавкуКомисиию(Договор, НоваяСтавка, НоваяКомиссия, Период = Неопределено) Экспорт
	
	НоваяСтавка = 0;
	НоваяКомиссия = 0;
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	ИсторияСтавок = СрезПоследних(Период, Новый Структура("Договор",Договор));
	Если ИсторияСтавок.Количество() > 0 Тогда
		
		НоваяСтавка = ИсторияСтавок[0].Процент;
		НоваяКомиссия = ИсторияСтавок[0].Комиссия;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли