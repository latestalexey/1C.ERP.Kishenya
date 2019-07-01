&НаКлиенте
Перем ВыполняетсяЗакрытие;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	КодОПФГ		  					= Параметры.КодОПФГ;
	ОПФГ		  					= Параметры.ОПФГ;
	КодКОАТУУ		  				= Параметры.КодКОАТУУ;
	Территория		  				= Параметры.Территория;
	КодКФВ		  					= Параметры.КодКФВ;
	ФормаСобственности		  		= Параметры.ФормаСобственности;
	КодСПОДУ		  				= Параметры.КодСПОДУ;
	ОрганГУ		  					= Параметры.ОрганГУ;
	КодЗКГНГ		  				= Параметры.КодЗКГНГ;
	Отрасль		  					= Параметры.Отрасль;
	КодКВЕД		  					= Параметры.КодКВЕД;
	ВЭД		  						= Параметры.ВЭД;
	КлассПрофессиональногоРиска 	= Параметры.КлассПрофессиональногоРиска;
			
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность И НЕ ВыполняетсяЗакрытие Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
			НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'"), 
			РежимДиалогаВопрос.ДаНетОтмена);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		
		Возврат;
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			ВыполняетсяЗакрытие = Истина;
			ЗаписатьЗакрыть();
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполняетсяЗакрытие = Истина;
	Закрыть();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КодОПФГПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОПФГПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КодКОАТУУПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТерриторияПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КодКФВПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ФормаСобственностиПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КодСПОДУПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОрганГУПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КодЗКГНГПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтрасльПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КодКВЕДПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВЭДПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КлассПрофессиональногоРискаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда) 
	
	ЗаписатьЗакрыть();	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗаписатьЗакрыть()
	
	Модифицированность = Ложь;
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("КодОПФГ", КодОПФГ);
	СтруктураПараметров.Вставить("ОПФГ", ОПФГ);
	СтруктураПараметров.Вставить("КодКОАТУУ", КодКОАТУУ);
	СтруктураПараметров.Вставить("Территория", Территория);
	СтруктураПараметров.Вставить("КодКФВ", КодКФВ);
	СтруктураПараметров.Вставить("ФормаСобственности", ФормаСобственности);
	СтруктураПараметров.Вставить("КодСПОДУ", КодСПОДУ);
	СтруктураПараметров.Вставить("ОрганГУ", ОрганГУ);
	СтруктураПараметров.Вставить("КодЗКГНГ", КодЗКГНГ);
	СтруктураПараметров.Вставить("Отрасль", Отрасль);
	СтруктураПараметров.Вставить("КодКВЕД", КодКВЕД);
	СтруктураПараметров.Вставить("ВЭД", ВЭД);
	СтруктураПараметров.Вставить("КлассПрофессиональногоРиска", КлассПрофессиональногоРиска);
	
	Закрыть(СтруктураПараметров);
	
КонецПроцедуры


ВыполняетсяЗакрытие = Ложь;
