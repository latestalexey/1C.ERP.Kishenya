#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru='Настройка параметров Интернет-поддержки недоступна при работе в модели сервиса.';uk='Настройка параметрів Інтернет-підтримки недоступна при роботі в моделі сервісу.'");
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
		// Право администрирования не проверяется, т.к. подсистема
		// используется только в локальном режиме.
		ВызватьИсключение
			НСтр("ru='Недостаточно прав доступа.
            |
            |Настройка параметров подключения к серверу Интернет-поддержки пользователей доступна только администратору системы.'
            |;uk='Недостатньо прав доступу.
            |
            |Настройка параметрів підключення до сервера Інтернет-підтримки користувачів доступна тільки адміністратору системи.'");
	КонецЕсли;
	
	
	ЭтоКлиентСервернаяИБ = (Не ОбщегоНазначения.ИнформационнаяБазаФайловая());
	КлючСохраненияПоложенияОкна = Строка(ЭтоКлиентСервернаяИБ);
	Элементы.ГруппаСоединение.Видимость                      = ЭтоКлиентСервернаяИБ;
	Элементы.ДекорацияПояснениеПодключениеССервера.Видимость = Элементы.ГруппаСоединение.Видимость;
	
	
	НастройкиСоединения = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	
	ДоменРасположенияСерверовИПП = НастройкиСоединения.ДоменРасположенияСерверовИПП;
	ПодключениеССервера          = ?(НастройкиСоединения.УстанавливатьПодключениеНаСервере, 1, 0);
	ТаймаутПодключения           = НастройкиСоединения.ТаймаутПодключения;
	
	ДанныеПриЧтении = Новый Структура("ДоменРасположенияСерверовИПП, ПодключениеССервера, ТаймаутПодключения",
		ДоменРасположенияСерверовИПП, ПодключениеССервера, ТаймаутПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПроверитьОткрытиеФормыПараметровИнтернетПоддержки" Тогда
		
		Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("ФормаОткрыта") Тогда
			Параметр.ФормаОткрыта = Открыта();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера",
		Новый Структура("НастройкаПроксиНаКлиенте",
			(НЕ Элементы.ГруппаСоединение.Видимость ИЛИ ТаймаутПодключения = 1)),
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗначенияНастроек = Новый Структура;
	Если ДанныеПриЧтении.ДоменРасположенияСерверовИПП <> ДоменРасположенияСерверовИПП Тогда
		ЗначенияНастроек.Вставить("ДоменРасположенияСерверовИПП", ДоменРасположенияСерверовИПП);
	КонецЕсли;
	
	Если Элементы.ГруппаСоединение.Видимость
		И ДанныеПриЧтении.ПодключениеССервера <> ПодключениеССервера Тогда
		ЗначенияНастроек.Вставить("ПодключениеССервера", ПодключениеССервера);
	КонецЕсли;
	
	Если ДанныеПриЧтении.ТаймаутПодключения <> ТаймаутПодключения Тогда
		ЗначенияНастроек.Вставить("ТаймаутПодключения", ТаймаутПодключения);
	КонецЕсли;
	
	Если ЗначенияНастроек.Количество() > 0 Тогда
		ЗаписатьНастройки(ЗначенияНастроек);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗаписатьНастройки(Знач ЗначенияНастроек)
	
	НачатьТранзакцию();
	
	Если ЗначенияНастроек.Свойство("ТаймаутПодключения") Тогда
		Константы.ТаймаутПодключенияКСервисуИнтернетПоддержки.Установить(ЗначенияНастроек.ТаймаутПодключения);
	КонецЕсли;
	
	Если ЗначенияНастроек.Свойство("ДоменРасположенияСерверовИПП") Тогда
		Константы.ДоменРасположенияСерверовИПП.Установить(ЗначенияНастроек.ДоменРасположенияСерверовИПП);
	КонецЕсли;
	
	Если ЗначенияНастроек.Свойство("ПодключениеССервера") Тогда
		Константы.ПодключениеКСервисуИППССервера.Установить((ЗначенияНастроек.ПодключениеССервера = 1));
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	Если ЗначенияНастроек.Свойство("ДоменРасположенияСерверовИПП") Тогда
		ИнтернетПоддержкаПользователей.ПриИзмененииДоменнойЗоныСерверовИПП(
			ЗначенияНастроек.ДоменРасположенияСерверовИПП);
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
