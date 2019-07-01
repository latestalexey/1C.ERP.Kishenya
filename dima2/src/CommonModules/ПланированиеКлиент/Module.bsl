////////////////////////////////////////////////////////////////////////////////
// Общие процедуры и функции планирования
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура - Изменить флаг отмены строк плана
//
// Параметры:
//  Форма				 - УправляемаяФорма				 - Форма документа плана
//  Таблица				 - ТаблицаЗначений, Коллекция	 - Таблица в которой устанавливается флаг отмены строки
//  ИмяЭлементаТаблицы	 - Строка						 - Имя элемента формы таблицы
//  ОповещениеОЗакрытии	 - ОписаниеОповещения			 - Оповещение, выполняемое после закрытия
Процедура ИзменитьФлагОтменыСтрокПлана(Форма, Таблица, ИмяЭлементаТаблицы, ОповещениеОЗакрытии = Неопределено) Экспорт 

	Элементы = Форма.Элементы;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ИмяЭлементаТаблицы", ИмяЭлементаТаблицы);
	ДополнительныеПараметры.Вставить("Таблица", Таблица);
	Если ОповещениеОЗакрытии <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ОповещениеОЗакрытии", ОповещениеОЗакрытии);
	КонецЕсли; 
	
	Если Форма.Объект.КроссТаблица Тогда
		
		Если Элементы[ИмяЭлементаТаблицы].ВыделенныеСтроки.Количество() = 0 Тогда
			ПоказатьОповещениеПользователя(НСтр("ru='Выделите строки в списке';uk='Виділіть рядки в списку'"));
			Возврат;
		КонецЕсли;
		
		АктивныеПериоды = Форма.Периоды.НайтиСтроки(Новый Структура("Активная", Истина));
		Если АктивныеПериоды.Количество() = 0  Тогда
			Возврат;
		КонецЕсли;
		
		Если АктивныеПериоды.Количество() > 1  Тогда
			
			ВыбранПериод = Ложь;
			ТекущийЭлементИмя = Элементы[ИмяЭлементаТаблицы].ТекущийЭлемент.Имя;
			Если СтрНайти(ТекущийЭлементИмя, ИмяЭлементаТаблицы + "Количество_") > 0
				ИЛИ СтрНайти(ТекущийЭлементИмя, ИмяЭлементаТаблицы + "Комментарий_") > 0
				ИЛИ СтрНайти(ТекущийЭлементИмя, ИмяЭлементаТаблицы + "Цена_") > 0
				ИЛИ СтрНайти(ТекущийЭлементИмя, ИмяЭлементаТаблицы + "Сумма_") > 0 Тогда
				ВыбранПериод = Истина;
			КонецЕсли;
			
			Если ВыбранПериод Тогда
				Для каждого Период Из АктивныеПериоды Цикл
					Если ТекущийЭлементИмя = ИмяЭлементаТаблицы + "Количество_"+Период.ИмяКолонки
						ИЛИ ТекущийЭлементИмя = ИмяЭлементаТаблицы + "КартинкаКомментарий_"+Период.ИмяКолонки
						ИЛИ ТекущийЭлементИмя = ИмяЭлементаТаблицы + "Цена_"+Период.ИмяКолонки
						ИЛИ ТекущийЭлементИмя = ИмяЭлементаТаблицы + "Сумма_"+Период.ИмяКолонки Тогда
						Прервать;
					КонецЕсли;
				КонецЦикла;
			Иначе
				Период = АктивныеПериоды[0];
			КонецЕсли; 
			
			Если Элементы[ИмяЭлементаТаблицы].ТекущиеДанные["Отменено_"+Период.ИмяКолонки] Тогда
				ТекстВопроса = НСтр("ru='Снять пометку отмены ячеек плана для всех периодов?';uk='Зняти позначку скасування комірок плану для всіх періодів?'");
			Иначе
				ТекстВопроса = НСтр("ru='Установить пометку отмены ячеек плана для всех периодов?';uk='Встановити позначку скасування комірок плану для всіх періодів?'");
			КонецЕсли; 
			
			ДополнительныеПараметры.Вставить("ИмяКолонки", Период.ИмяКолонки);
			ДополнительныеПараметры.Вставить("Отменено",   НЕ Элементы[ИмяЭлементаТаблицы].ТекущиеДанные["Отменено_"+Период.ИмяКолонки]);
			
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Да, для всех';uk='Так, для всіх'"));
			Кнопки.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru='Только';uk='Тільки'") + " " + Период.Заголовок);
			Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена';uk='Відмінити'"));
			
			Оповещение = Новый ОписаниеОповещения("ИзменитьФлагОтменыСтрокПланаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			
			ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
		Иначе
		
			Период = АктивныеПериоды[0];
			
			ДополнительныеПараметры.Вставить("ИмяКолонки", Период.ИмяКолонки);
			ДополнительныеПараметры.Вставить("Отменено",   НЕ Элементы[ИмяЭлементаТаблицы].ТекущиеДанные["Отменено_"+Период.ИмяКолонки]);
			ИзменитьФлагОтменыСтрокПланаЗавершение(КодВозвратаДиалога.Нет, ДополнительныеПараметры);
		
		КонецЕсли; 
	Иначе
		
		Если Элементы[ИмяЭлементаТаблицы].ВыделенныеСтроки.Количество() = 0 Тогда
			ПоказатьОповещениеПользователя(НСтр("ru='Выделите строки в списке';uk='Виділіть рядки в списку'"));
			Возврат;
		КонецЕсли;
		
		ДополнительныеПараметры.Вставить("Отменено", НЕ Элементы[ИмяЭлементаТаблицы].ТекущиеДанные.Отменено);
		ИзменитьФлагОтменыСтрокПланаЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
		
	КонецЕсли;

КонецПроцедуры

// Процедура - Показать вопрос при изменении сценария
//
// Параметры:
//  Форма				 - УправляемаяФорма				 - Форма документа плана
//  ОповещениеОЗакрытии	 - ОписаниеОповещения			 - Оповещение, выполняемое после закрытия
Процедура ПоказатьВопросПриИзмененииСценария(Форма, ОповещениеОЗакрытии = Неопределено) Экспорт 
	
	Если ЗначениеЗаполнено(Форма["РеквизитыДоИзменения"].Сценарий) Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		Если ОповещениеОЗакрытии <> Неопределено Тогда
			ДополнительныеПараметры.Вставить("ОповещениеОЗакрытии", ОповещениеОЗакрытии);
		КонецЕсли; 
		
		Оповещение = Новый ОписаниеОповещения(
			"ПоказатьВопросПриИзмененииСценарияЗавершение", 
			ЭтотОбъект, 
			ДополнительныеПараметры);
		
		ТекстВопроса = НСтр("ru='Сценарий изменен. Правило заполнения будет обновлено. Обновить?';uk='Сценарій змінено. Правило заповнення буде оновлено. Оновити?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Обновить';uk='Оновити'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Отменить изменение сценария';uk='Скасувати зміну сценарію'"));
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
		
		
	ИначеЕсли ОповещениеОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Показать вопрос при изменении вид плана
//
// Параметры:
//  Форма				 - УправляемаяФорма				 - Форма документа плана
//  ОповещениеОЗакрытии	 - ОписаниеОповещения			 - Оповещение, выполняемое после закрытия
Процедура ПоказатьВопросПриИзмененииВидПлана(Форма, ОповещениеОЗакрытии = Неопределено) Экспорт 
	
	Если ЗначениеЗаполнено(Форма["РеквизитыДоИзменения"].Сценарий) Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		Если ОповещениеОЗакрытии <> Неопределено Тогда
			ДополнительныеПараметры.Вставить("ОповещениеОЗакрытии", ОповещениеОЗакрытии);
		КонецЕсли; 
		
		Оповещение = Новый ОписаниеОповещения(
			"ПоказатьВопросПриИзмененииВидПланаЗавершение", 
			ЭтотОбъект, 
			ДополнительныеПараметры);
		
		ТекстВопроса = НСтр("ru='Вид плана изменен. Правило заполнения будет обновлено. Обновить?';uk='Вид плану змінено. Правило заповнення буде оновлено. Оновити?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Обновить';uk='Оновити'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Отменить изменение вида плана';uk='Скасувати зміну виду плану'"));
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
		
		
	ИначеЕсли ОповещениеОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Изменить формулу на процент
//
// Параметры:
//  Форма				 - УправляемаяФорма				 - Форма документа плана
//  Таблица				 - ТаблицаЗначений, Коллекция	 - Таблица в которой устанавливается формула
//  ИмяЭлементаТаблицы	 - Строка						 - Имя элемента формы таблицы
//  ОповещениеОЗакрытии	 - ОписаниеОповещения			 - Оповещение, выполняемое после закрытия
Процедура ИзменитьФормулуНаПроцент(Форма, Таблица, ИмяЭлементаТаблицы, ОповещениеОЗакрытии = Неопределено) Экспорт 

	Элементы = Форма.Элементы;
	ВыделенныеСтроки = Элементы[ИмяЭлементаТаблицы].ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0  Тогда
	
		ПоказатьПредупреждение(, НСтр("ru='Необходимо выделить строки в списке!';uk='Необхідно виділити рядки в списку!'"));
		Возврат;
	
	КонецЕсли; 
	
	АктивныеПериоды = Форма.Периоды.НайтиСтроки(Новый Структура("Активная", Истина));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ИмяЭлементаТаблицы", ИмяЭлементаТаблицы);
	ДополнительныеПараметры.Вставить("Таблица", Таблица);
	Если ОповещениеОЗакрытии <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ОповещениеОЗакрытии", ОповещениеОЗакрытии);
	КонецЕсли; 
	
	Если Форма.Объект.КроссТаблица И АктивныеПериоды.Количество() > 1 Тогда
	
		ТекущийЭлементИмя = Элементы[ИмяЭлементаТаблицы].ТекущийЭлемент.Имя;
		
		Если СтрНайти(ТекущийЭлементИмя, ИмяЭлементаТаблицы + "Количество_") = 0 Тогда
			Период = АктивныеПериоды[0];
		Иначе
			Для каждого Период Из АктивныеПериоды Цикл
				Если ТекущийЭлементИмя = ИмяЭлементаТаблицы + "Количество_"+Период.ИмяКолонки Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		 
		ТекстВопроса = НСтр("ru='Установить формулу для всех периодов?';uk='Встановити формулу для всіх періодів?'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Да, для всех';uk='Так, для всіх'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru='Только';uk='Тільки'") + " " + Период.Заголовок);
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена';uk='Відмінити'"));
		
		ДополнительныеПараметры.Вставить("ИмяКолонки",Период.ИмяКолонки);
		
		Оповещение = Новый ОписаниеОповещения("ВвестиПроцентИИзменитьФормулу", ЭтотОбъект, ДополнительныеПараметры);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
		
	ИначеЕсли Форма.Объект.КроссТаблица И АктивныеПериоды.Количество() = 1 Тогда
		
		Период = АктивныеПериоды[0];
		ДополнительныеПараметры.Вставить("ИмяКолонки",Период.ИмяКолонки);
		ВвестиПроцентИИзменитьФормулу(КодВозвратаДиалога.Нет, ДополнительныеПараметры);
		
	Иначе
		
		ВвестиПроцентИИзменитьФормулу(КодВозвратаДиалога.Нет, ДополнительныеПараметры);
	
	КонецЕсли; 

КонецПроцедуры

// Процедура - Округлить формулу
//
// Параметры:
//  Форма				 - УправляемаяФорма				 - Форма документа плана
//  Таблица				 - ТаблицаЗначений, Коллекция	 - Таблица в которой устанавливается формула
//  ИмяЭлементаТаблицы	 - Строка						 - Имя элемента формы таблицы
//  ОповещениеОЗакрытии	 - ОписаниеОповещения			 - Оповещение, выполняемое после закрытия
Процедура ОкруглитьФормулу(Форма, Таблица, ИмяЭлементаТаблицы, ОповещениеОЗакрытии = Неопределено) Экспорт 

	Элементы = Форма.Элементы;
	ВыделенныеСтроки = Элементы[ИмяЭлементаТаблицы].ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0  Тогда
	
		ПоказатьПредупреждение(, НСтр("ru='Необходимо выделить строки в списке!';uk='Необхідно виділити рядки в списку!'"));
		Возврат;
	
	КонецЕсли; 
	
	АктивныеПериоды = Форма.Периоды.НайтиСтроки(Новый Структура("Активная", Истина));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ИмяЭлементаТаблицы", ИмяЭлементаТаблицы);
	ДополнительныеПараметры.Вставить("Таблица", Таблица);
	Если ОповещениеОЗакрытии <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ОповещениеОЗакрытии", ОповещениеОЗакрытии);
	КонецЕсли; 
	
	Если Форма.Объект.КроссТаблица И АктивныеПериоды.Количество() > 1 Тогда
	
		ТекущийЭлементИмя = Элементы[ИмяЭлементаТаблицы].ТекущийЭлемент.Имя;
		
		Если СтрНайти(ТекущийЭлементИмя, ИмяЭлементаТаблицы + "Количество_") = 0 Тогда
			Период = АктивныеПериоды[0];
		Иначе
			Для каждого Период Из АктивныеПериоды Цикл
				Если ТекущийЭлементИмя = ИмяЭлементаТаблицы + "Количество_"+Период.ИмяКолонки Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		 
		ТекстВопроса = НСтр("ru='Установить формулу для всех периодов?';uk='Встановити формулу для всіх періодів?'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Да, для всех';uk='Так, для всіх'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru='Только';uk='Тільки'") + " " + Период.Заголовок);
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена';uk='Відмінити'"));
		
		ДополнительныеПараметры.Вставить("ИмяКолонки",Период.ИмяКолонки);
		
		Оповещение = Новый ОписаниеОповещения("ВыбратьТочностьОкругленияИИзменитьФормулу", ЭтотОбъект, ДополнительныеПараметры);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
		
	ИначеЕсли Форма.Объект.КроссТаблица И АктивныеПериоды.Количество() = 1 Тогда
		
		Период = АктивныеПериоды[0];
		ДополнительныеПараметры.Вставить("ИмяКолонки",Период.ИмяКолонки);
		ВыбратьТочностьОкругленияИИзменитьФормулу(КодВозвратаДиалога.Нет, ДополнительныеПараметры);
		
	Иначе
		
		ВыбратьТочностьОкругленияИИзменитьФормулу(КодВозвратаДиалога.Нет, ДополнительныеПараметры);
	
	КонецЕсли; 

КонецПроцедуры

Процедура ПриИзмененииПериодаПлана(Форма, Знач ИмяКроссТаблицы, ОповещениеОбновленияИнтерфейса) Экспорт 
	
	Объект = Форма.Объект;
	ПланированиеКлиентСервер.УстановитьНачалоОкончаниеПериодаПлана(Объект.Периодичность, Объект.НачалоПериода, Объект.ОкончаниеПериода);
	
	Если ПланированиеКлиентСервер.НеобходимоОбновитьИнтерфейс(Объект, Форма, "РеквизитыДоИзменения") Тогда
		
		КроссТаблица = Форма[ИмяКроссТаблицы];
		Если Объект.КроссТаблица
			И КроссТаблица.Количество() > 0
			И Форма.Периоды.НайтиСтроки(Новый Структура("Активная", Истина)).Количество() > 0 Тогда
			ЗадаватьВопрос = Ложь;
			
			Если Форма["РеквизитыДоИзменения"].НачалоПериода <> Объект.НачалоПериода 
				И Объект.НачалоПериода > Форма["РеквизитыДоИзменения"].НачалоПериода Тогда
				ЗадаватьВопрос = Истина;
			КонецЕсли; 
			
			Если Форма["РеквизитыДоИзменения"].ОкончаниеПериода <> Объект.ОкончаниеПериода 
				И Объект.ОкончаниеПериода < Форма["РеквизитыДоИзменения"].ОкончаниеПериода Тогда
				ЗадаватьВопрос = Истина;
			КонецЕсли;
			
			Если ЗадаватьВопрос Тогда
				Кнопки = Новый СписокЗначений;
				Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Удалить периоды';uk='Видалити періоди'"));
				Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Отменить изменение периода';uk='Скасувати зміну періоду'"));
				ТекстВопроса = НСтр("ru='Изменение периода плана приведет к удалению данных в некоторых периодах. Удалить периоды?';uk='Зміна періоду плану призведе до вилучення даних в деяких періодах. Вилучити періоди?'");
				
				ДополнительныеПараметры = Новый Структура;
				ДополнительныеПараметры.Вставить("Форма", Форма);
				ДополнительныеПараметры.Вставить("ОповещениеОбновленияИнтерфейса", ОповещениеОбновленияИнтерфейса);
				Оповещение = Новый ОписаниеОповещения("ПриИзмененииПериодаПланаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
				
				ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
		ВыполнитьОбработкуОповещения(ОповещениеОбновленияИнтерфейса);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИзменитьФлагОтменыСтрокПланаЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено ИЛИ Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ИмяЭлементаТаблицы = ДополнительныеПараметры.ИмяЭлементаТаблицы;
	Элементы = Форма.Элементы;
	
	Если Форма.Объект.КроссТаблица Тогда
		
		ВыделенныеСтроки = Элементы[ИмяЭлементаТаблицы].ВыделенныеСтроки;
		
		Если Результат = КодВозвратаДиалога.Да Тогда
		
			АктивныеПериоды = Форма.Периоды.НайтиСтроки(Новый Структура("Активная", Истина));
			Если АктивныеПериоды.Количество() = 0  Тогда
				Возврат;
			КонецЕсли;
			
			Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
				
				СтрокаТЧ = ДополнительныеПараметры.Таблица.НайтиПоИдентификатору(ВыделеннаяСтрока);
				Для каждого Период Из АктивныеПериоды Цикл
					СтрокаТЧ["Отменено_"+Период.ИмяКолонки] = ДополнительныеПараметры.Отменено;
				КонецЦикла;
				
			КонецЦикла; 
			
		Иначе
		
			Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
				
				СтрокаТЧ = ДополнительныеПараметры.Таблица.НайтиПоИдентификатору(ВыделеннаяСтрока);
				СтрокаТЧ["Отменено_"+ДополнительныеПараметры.ИмяКолонки] = ДополнительныеПараметры.Отменено;
				
			КонецЦикла; 
		
		КонецЕсли; 
	
	Иначе
	
		ВыделенныеСтроки = Элементы[ИмяЭлементаТаблицы].ВыделенныеСтроки;
		Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
			СтрокаТЧ = ДополнительныеПараметры.Таблица.НайтиПоИдентификатору(ВыделеннаяСтрока);
			СтрокаТЧ.Отменено = ДополнительныеПараметры.Отменено;
		
		КонецЦикла; 
	
	КонецЕсли; 
	
	Если ДополнительныеПараметры.Свойство("ОповещениеОЗакрытии") Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьВопросПриИзмененииСценарияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		ПланированиеКлиентСервер.ВосстановитьЗначенияИзПроверяемыхРеквизитов(
			ДополнительныеПараметры.Форма.Объект, 
			ДополнительныеПараметры.Форма, 
			"РеквизитыДоИзменения", 
			"Сценарий, ВидПлана");
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ОповещениеОЗакрытии") Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьВопросПриИзмененииВидПланаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		ПланированиеКлиентСервер.ВосстановитьЗначенияИзПроверяемыхРеквизитов(
			ДополнительныеПараметры.Форма.Объект, 
			ДополнительныеПараметры.Форма, 
			"РеквизитыДоИзменения", 
			"ВидПлана");
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ОповещениеОЗакрытии") Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВвестиПроцентИИзменитьФормулу(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ДополнительныеПараметры.Вставить("ИмяКолонки", "ВсеПериоды");
	ИначеЕсли Результат <> КодВозвратаДиалога.Нет Тогда
		Если ДополнительныеПараметры.Свойство("ОповещениеОЗакрытии") Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВвестиПроцентИИзменитьФормулуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПоказатьВводЧисла(Оповещение, 0, НСтр("ru='Введите процент';uk='Введіть відсоток'"), 5, 2);
	
КонецПроцедуры

Процедура ВвестиПроцентИИзменитьФормулуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено или Результат = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Процент = Формат(1 + Результат / 100 ,"ЧЦ=15; ЧДЦ=4; ЧРД=.");
	
	ШаблонФормулы = НСтр("ru='(%ТекущаяФормула%) * %Процент%';uk='(%ТекущаяФормула%) * %Процент%'");
	ШаблонФормулы = СтрЗаменить(ШаблонФормулы, "%Процент%", Процент);
	
	ИзменитьФормулуВыделенныхСтрокПоШаблону(Результат, ДополнительныеПараметры, ШаблонФормулы);
	
КонецПроцедуры

Процедура ВыбратьТочностьОкругленияИИзменитьФормулу(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ДополнительныеПараметры.Вставить("ИмяКолонки", "ВсеПериоды");
	ИначеЕсли Результат <> КодВозвратаДиалога.Нет Тогда
		Если ДополнительныеПараметры.Свойство("ОповещениеОЗакрытии") Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СписокЗначений = Новый СписокЗначений();
	СписокЗначений.Добавить( 3, "0,001");
	СписокЗначений.Добавить( 2, "0,01");
	СписокЗначений.Добавить( 1, "0,1");
	СписокЗначений.Добавить( 0, "1");
	СписокЗначений.Добавить(-1, "10");
	СписокЗначений.Добавить(-2, "100");
	СписокЗначений.Добавить(-3, "1000");
	
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьТочностьОкругленияИИзменитьФормулуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	СписокЗначений.ПоказатьВыборЭлемента(Оповещение,НСтр("ru='Точность округления';uk='Точність округлення'"));
	
КонецПроцедуры

Процедура ВыбратьТочностьОкругленияИИзменитьФормулуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонФормулы = НСтр("ru='Окр((%ТекущаяФормула%), %ТочностьОкругления%)';uk='Окр((%ТекущаяФормула%), %ТочностьОкругления%)'");
	ШаблонФормулы = СтрЗаменить(ШаблонФормулы, "%ТочностьОкругления%", Результат.Значение);
	
	ИзменитьФормулуВыделенныхСтрокПоШаблону(Результат, ДополнительныеПараметры, ШаблонФормулы);
	
КонецПроцедуры

Процедура ИзменитьФормулуВыделенныхСтрокПоШаблону(Результат, Параметры, ШаблонФормулы)
	
	Форма = Параметры.Форма;
	Элементы = Форма.Элементы;
	ИмяЭлементаТаблицы = Параметры.ИмяЭлементаТаблицы;
	Таблица = Параметры.Таблица;
	
	ВыделенныеСтроки = Элементы[ИмяЭлементаТаблицы].ВыделенныеСтроки;
	
	Если Форма.Объект.КроссТаблица Тогда
		
		ИмяКолонки = Параметры.ИмяКолонки;
		
		Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			
			Если ИмяКолонки = "ВсеПериоды" Тогда
				Периоды = Форма.Периоды.НайтиСтроки(Новый Структура("Активная", Истина));
			Иначе
				Периоды = Форма.Периоды.НайтиСтроки(Новый Структура("Активная, ИмяКолонки", Истина, ИмяКолонки))
			КонецЕсли;
			
			Для каждого Период Из Периоды Цикл
				
				СтрокаТЧ = Таблица.НайтиПоИдентификатору(ВыделеннаяСтрока);
				Если ЗначениеЗаполнено(СтрокаТЧ["Формула_" + Период.ИмяКолонки]) Тогда
					СтрокаТЧ["Формула_" + Период.ИмяКолонки] = СтрЗаменить(ШаблонФормулы, "%ТекущаяФормула%", СтрокаТЧ["Формула_" + Период.ИмяКолонки]);
				Иначе
					СтрокаТЧ["Формула_" + Период.ИмяКолонки] = Формат(СтрокаТЧ["Количество_" + Период.ИмяКолонки], "ЧРД=.; ЧН=0; ЧГ=0");
					СтрокаТЧ["Формула_" + Период.ИмяКолонки] = СтрЗаменить(ШаблонФормулы, "%ТекущаяФормула%", СтрокаТЧ["Формула_" + Период.ИмяКолонки]);
				КонецЕсли; 
				РезультатВычисления = ПланированиеКлиентСервер.ВычислитьПоФормуле(СтрокаТЧ["Формула_" + Период.ИмяКолонки], СтрокаТЧ, Период.ИмяКолонки);
				СтрокаТЧ["ФормулаВычисление_" + Период.ИмяКолонки] = РезультатВычисления.Вычисление;
				СтрокаТЧ["Количество_" + Период.ИмяКолонки]= РезультатВычисления.Результат;
				СтрокаТЧ["Отклонение_" + Период.ИмяКолонки]= 0;
				
			КонецЦикла;
			
		КонецЦикла; 

	Иначе
		
		Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			
			СтрокаТЧ = Таблица.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Если ЗначениеЗаполнено(СтрокаТЧ.Формула) Тогда
				СтрокаТЧ.Формула = СтрЗаменить(ШаблонФормулы, "%ТекущаяФормула%", СтрокаТЧ.Формула);
			Иначе
				СтрокаТЧ.Формула = Формат(СтрокаТЧ.КоличествоУпаковок, "ЧРД=.; ЧН=0; ЧГ=0");
				СтрокаТЧ.Формула = СтрЗаменить(ШаблонФормулы, "%ТекущаяФормула%", СтрокаТЧ.Формула);
			КонецЕсли; 
			РезультатВычисления = ПланированиеКлиентСервер.ВычислитьПоФормуле(СтрокаТЧ.Формула, СтрокаТЧ);
			СтрокаТЧ.ФормулаВычисление = РезультатВычисления.Вычисление;
			СтрокаТЧ.КоличествоУпаковок = РезультатВычисления.Результат;
			СтрокаТЧ.Отклонение = 0;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ОповещениеОЗакрытии") Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеОЗакрытии, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииПериодаПланаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
	
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОбновленияИнтерфейса);
	
	Иначе
	
		ПланированиеКлиентСервер.ВосстановитьЗначенияИзПроверяемыхРеквизитов(
			ДополнительныеПараметры.Форма.Объект, 
			ДополнительныеПараметры.Форма, 
			"РеквизитыДоИзменения", 
			"НачалоПериода, ОкончаниеПериода");
	
	КонецЕсли; 
	
КонецПроцедуры


#КонецОбласти