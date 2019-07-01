#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ВнутреннееСостояние

Перем ТекущийКонтейнер;
Перем ТекущиеОбработчики;
Перем ТекущееИмяХранилищаНастроек;
Перем ТекущееХранилищеНастроек;
Перем ТекущийСериализатор;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, ИмяХранилищаНастроек, Обработчики, Сериализатор) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущееИмяХранилищаНастроек = ИмяХранилищаНастроек;
	ТекущиеОбработчики = Обработчики;
	ТекущийСериализато = Сериализатор;
	
	ТекущееХранилищеНастроек = РаботаВБезопасномРежиме.ВычислитьВБезопасномРежиме(ИмяХранилищаНастроек);
	
КонецПроцедуры

Процедура ВыгрузитьДанные() Экспорт
	
	Если ТекущееИмяХранилищаНастроек <> "ХранилищеСистемныхНастроек" И Метаданные[ТекущееИмяХранилищаНастроек] <> Неопределено Тогда
		// Выполняется выгрузка данных только из стандартных хранилищ настроек.
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ТекущиеОбработчики.ПередВыгрузкойХранилищаНастроек(
		ТекущийКонтейнер,
		ТекущийСериализатор,
		ТекущееИмяХранилищаНастроек,
		ТекущееХранилищеНастроек,
		Отказ);
	
	Если Не Отказ Тогда
		
		ВыгрузитьНастройкиСтандартногоХранилища();
		
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеВыгрузкиХранилищаНастроек(
		ТекущийКонтейнер,
		ТекущийСериализатор,
		ТекущееИмяХранилищаНастроек,
		ТекущееХранилищеНастроек
	);
	
КонецПроцедуры

Процедура Закрыть() Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыгрузитьНастройкиСтандартногоХранилища()
	
	ИмяФайла = ТекущийКонтейнер.СоздатьФайл(
		ВыгрузкаЗагрузкаДанныхСлужебный.UserSettings(),
		ТекущееИмяХранилищаНастроек);
	
	ПотокЗаписи = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы.Создать();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла, ТекущийСериализатор);
	
	// Выгружаются настройки только существующих пользователей информационной базы
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
	
		Выборка = ТекущееХранилищеНастроек.Выбрать(Новый Структура("Пользователь", ПользовательИБ.Имя));
		
		Продолжать = Истина;
		
		Пока Продолжать Цикл
			
			Попытка
				
				Продолжать = Выборка.Следующий();
				
			Исключение
				
				ЗаписьЖурналаРегистрации(
					НСтр("ru='ВыгрузкаЗагрузкаДанных.ВыгрузкаНастройкиПропущена';uk='ВыгрузкаЗагрузкаДанных.ВыгрузкаНастройкиПропущена'",Метаданные.ОсновнойЯзык.КодЯзыка),
					УровеньЖурналаРегистрации.Предупреждение,,,
					СтрШаблон(НСтр("ru='Выгрузка настройки пропущена, т.к. настройка не может быть прочитана:
                            |КлючНастроек=%1
                            |КлючОбъекта=%2
                            |Пользователь=%3
                            |Представление=%4
                            |'
                            |;uk='Вивантаження настройки пропущене, оскільки настройка не може бути прочитана:
                            |КлючНастроек=%1
                            |КлючОбъекта=%2
                            |Пользователь=%3
                            |Представление=%4
                            |'",Метаданные.ОсновнойЯзык.КодЯзыка),
						Выборка.КлючНастроек,
						Выборка.КлючОбъекта,
						Выборка.Пользователь,
						Выборка.Представление
					)
				);
				
				Продолжать = Истина;
				Продолжить;
				
			КонецПопытки;
		
			ВыгрузитьЭлементНастроек(
				ПотокЗаписи,
				Выборка.КлючНастроек,
				Выборка.КлючОбъекта,
				Выборка.Пользователь,
				Выборка.Представление,
				Выборка.Настройки);
		
		КонецЦикла;
			
	КонецЦикла;
	
	ПотокЗаписи.Закрыть();
	
	КоличествоОбъектов = ПотокЗаписи.КоличествоОбъектов();
	Если КоличествоОбъектов = 0 Тогда
		ТекущийКонтейнер.ИсключитьФайл(ИмяФайла);
	Иначе
		ТекущийКонтейнер.УстановитьКоличествоОбъектов(ИмяФайла, КоличествоОбъектов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыгрузитьЭлементНастроек(ПотокЗаписи, Знач КлючНастроек, Знач КлючОбъекта, Знач Пользователь, Знач Представление, Знач Настройки)
	
	Отказ = Ложь;
	
	Если НайтиНедопустимыеСимволыXML(КлючНастроек) > 0
		ИЛИ НайтиНедопустимыеСимволыXML(КлючОбъекта) > 0
		ИЛИ НайтиНедопустимыеСимволыXML(Пользователь) > 0
		ИЛИ НайтиНедопустимыеСимволыXML(Представление) > 0 Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru='ВыгрузкаЗагрузкаДанных.ВыгрузкаНастройкиПропущена';uk='ВыгрузкаЗагрузкаДанных.ВыгрузкаНастройкиПропущена'",Метаданные.ОсновнойЯзык.КодЯзыка),
			УровеньЖурналаРегистрации.Предупреждение,,,
			НСтр("ru='Выгрузка настройки пропущена, т.к. в ключевых параметрах содержатся недопустимые символы.';uk='Вивантаження настройки пропущене, оскільки в ключових параметрах містить неприпустимі символи.'",Метаданные.ОсновнойЯзык.КодЯзыка));
		
		Отказ = Истина;
		
	КонецЕсли;
	
	Артефакты = Новый Массив();
	
	ТекущиеОбработчики.ПередВыгрузкойНастроек(
		ТекущийКонтейнер,
		ТекущийСериализатор,
		ТекущееИмяХранилищаНастроек,
		КлючНастроек,
		КлючОбъекта,
		Настройки,
		Пользователь,
		Представление,
		Артефакты,
		Отказ
	);
	
	СериализацияЧерезХранилищеЗначения = Ложь;
	Если Не НастройкиСериализуютсяВXDTO(Настройки) Тогда
		Настройки = Новый ХранилищеЗначения(Настройки);
		СериализацияЧерезХранилищеЗначения = Истина;
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		ЗаписьНастроек = Новый Структура();
		ЗаписьНастроек.Вставить("КлючНастроек", КлючНастроек);
		ЗаписьНастроек.Вставить("КлючОбъекта", КлючОбъекта);
		ЗаписьНастроек.Вставить("Пользователь", Пользователь);
		ЗаписьНастроек.Вставить("Представление", Представление);
		ЗаписьНастроек.Вставить("СериализацияЧерезХранилищеЗначения", СериализацияЧерезХранилищеЗначения);
		ЗаписьНастроек.Вставить("Настройки", Настройки);
		
		ПотокЗаписи.ЗаписатьОбъектДанныхИнформационнойБазы(ЗаписьНастроек, Артефакты);
		
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеВыгрузкиНастроек(
		ТекущийКонтейнер,
		ТекущийСериализатор,
		ТекущееИмяХранилищаНастроек,
		КлючНастроек,
		КлючОбъекта,
		Настройки,
		Пользователь,
		Представление
	);
	
КонецПроцедуры

Функция НастройкиСериализуютсяВXDTO(Знач Настройки)
	
	Результат = Истина;
	
	Попытка
		
		ПотокПроверки = Новый ЗаписьXML();
		ПотокПроверки.УстановитьСтроку();
		
		СериализаторXDTO.ЗаписатьXML(ПотокПроверки, Настройки);
		
	Исключение
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли