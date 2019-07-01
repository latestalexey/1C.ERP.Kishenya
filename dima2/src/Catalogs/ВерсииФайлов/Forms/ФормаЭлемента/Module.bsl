
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Файлы") Тогда
		Элементы.ПолноеНаименование.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.Автор.ТолькоПросмотр = Ложь;
		Элементы.ДатаСоздания.ТолькоПросмотр = Ложь;
		Элементы.РодительскаяВерсия.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ГруппаХранение.Видимость = Ложь;
	КонецЕсли;
	
	ТомПолныйПуть = ФайловыеФункцииСлужебный.ПолныйПутьТома(Объект.Том);
	
	ОбщиеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ОбщиеНастройкиРаботыСФайлами();
	
	РасширениеФайлаВСписке = ФайловыеФункцииСлужебныйКлиентСервер.РасширениеФайлаВСписке(
		ОбщиеНастройки.СписокРасширенийТекстовыхФайлов, Объект.Расширение);
	
	Если РасширениеФайлаВСписке Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			
			КодировкаЗначение = РаботаСФайламиСлужебныйВызовСервера.ПолучитьКодировкуВерсииФайла(Объект.Ссылка);
			
			СписокКодировок = РаботаСФайламиСлужебный.ПолучитьСписокКодировок();
			ЭлементСписка = СписокКодировок.НайтиПоЗначению(КодировкаЗначение);
			Если ЭлементСписка = Неопределено Тогда
				Кодировка = КодировкаЗначение;
			Иначе	
				Кодировка = ЭлементСписка.Представление;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Кодировка) Тогда
			Кодировка = НСтр("ru='По умолчанию';uk='По умовчанню'");
		КонецЕсли;
	Иначе
		Элементы.Кодировка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_Файл", Новый Структура("Событие", "ВерсияСохранена"), Объект.Владелец);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОткрытьВыполнить()
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	Объект.Наименование = Объект.ПолноеНаименование;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти
