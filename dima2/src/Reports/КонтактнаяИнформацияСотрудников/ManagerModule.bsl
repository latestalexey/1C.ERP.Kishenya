#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
		
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	ВариантыНастроек = Новый Массив;
	
	ПоляНастройки = "Имя, Представление";
	ВариантыНастроек.Добавить(Новый Структура(ПоляНастройки, "КонтактнаяИнформацияСотрудников", НСтр("ru='Контактная информация сотрудников';uk='Контактна інформація співробітників'")));
	
	Возврат ВариантыНастроек;
	
КонецФункции

#КонецОбласти

#КонецЕсли