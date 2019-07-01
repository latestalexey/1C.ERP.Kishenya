////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Функция ПроверитьПодпись(АдресИсходныхДанных, АдресПодписи, ОписаниеОшибки) Экспорт
	
	Возврат ЭлектроннаяПодпись.ПроверитьПодпись(Неопределено, АдресИсходныхДанных, АдресПодписи, ОписаниеОшибки);
	
КонецФункции

// Только для внутреннего использования.
Функция ПроверитьСертификат(АдресСертификата, ОписаниеОшибки, НаДату) Экспорт
	
	Возврат ЭлектроннаяПодпись.ПроверитьСертификат(Неопределено, АдресСертификата, ОписаниеОшибки, НаДату);
	
КонецФункции

// Только для внутреннего использования.
Функция СсылкаНаСертификат(Отпечаток, АдресСертификата) Экспорт
	
	Если ЗначениеЗаполнено(АдресСертификата) Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДвоичныеДанные);
		Отпечаток = Base64Строка(Сертификат.Отпечаток);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Отпечаток", Отпечаток);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сертификаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
	|ГДЕ
	|	Сертификаты.Отпечаток = &Отпечаток";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Только для внутреннего использования.
Функция ПредставлениеСертификата(АдресСертификата) Экспорт
	
	ДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
	
	СертификатКриптографии = Новый СертификатКриптографии(ДанныеСертификата);
	
	АдресСертификата = ПоместитьВоВременноеХранилище(ДанныеСертификата);
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ПредставлениеСертификата(СертификатКриптографии, Истина, Ложь);
	
КонецФункции

// Только для внутреннего использования.
Функция ВыполнитьНаСторонеСервера(Знач Параметры, АдресРезультата, ОперацияНачалась, ОшибкаНаСервере) Экспорт
	
	МенеджерКриптографии = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии(Параметры.Операция,
		Ложь, ОшибкаНаСервере, Параметры.СертификатПрограмма);
	
	Если МенеджерКриптографии = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Если личный сертификат шифрования не используется, тогда его не нужно искать.
	Если Параметры.Операция <> "Шифрование"
	 Или ЗначениеЗаполнено(Параметры.СертификатОтпечаток) Тогда
		
		СертификатКриптографии = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(
			Параметры.СертификатОтпечаток, Истина, Ложь, Параметры.СертификатПрограмма, ОшибкаНаСервере);
		
		Если СертификатКриптографии = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		Данные = ПолучитьИзВременногоХранилища(Параметры.ЭлементДанныхДляСервера.Данные);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОшибкаНаСервере.Вставить("ОписаниеОшибки",
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаголовокОшибкиПолученияДанных(Параметры.Операция)
			+ Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат Ложь;
	КонецПопытки;
	
	ОписаниеОшибки = "";
	Если Параметры.Операция = "Подписание" Тогда
		МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = Параметры.ЗначениеПароля;
		Попытка
			ДвоичныеДанныеРезультата = МенеджерКриптографии.Подписать(Данные, СертификатКриптографии);
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеДанныеПодписи(ДвоичныеДанныеРезультата, ОписаниеОшибки);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
	ИначеЕсли Параметры.Операция = "Шифрование" Тогда
		Сертификаты = СертификатыКриптографии(Параметры.АдресСертификатов);
		Попытка
			ДвоичныеДанныеРезультата = МенеджерКриптографии.Зашифровать(Данные, Сертификаты);
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеЗашифрованныеДанные(ДвоичныеДанныеРезультата, ОписаниеОшибки);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
	Иначе // Расшифровка.
		МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = Параметры.ЗначениеПароля;
		Попытка
			ДвоичныеДанныеРезультата = МенеджерКриптографии.Расшифровать(Данные);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
	КонецЕсли;
	
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ОшибкаНаСервере.Вставить("ОписаниеОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		ОшибкаНаСервере.Вставить("Инструкция", Истина);
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОшибкаНаСервере.Вставить("ОписаниеОшибки", ОписаниеОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	ОперацияНачалась = Истина;
	
	Если Параметры.Операция = "Подписание" Тогда
		СвойстваСертификата = ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(СертификатКриптографии);
		СвойстваСертификата.Вставить("ДвоичныеДанные", СертификатКриптографии.Выгрузить());
		
		СвойстваПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.СвойстваПодписи(ДвоичныеДанныеРезультата,
			СвойстваСертификата, Параметры.Комментарий);
		
		Если Параметры.СертификатВерен <> Неопределено Тогда
			СвойстваПодписи.ДатаПодписи = ТекущаяДатаСеанса();
			СвойстваПодписи.ДатаПроверкиПодписи = СвойстваПодписи.ДатаПодписи;
			СвойстваПодписи.ПодписьВерна = Параметры.СертификатВерен;
		КонецЕсли;
		
		АдресРезультата = ПоместитьВоВременноеХранилище(СвойстваПодписи, Параметры.ИдентификаторФормы);
		
		Если Параметры.ЭлементДанныхДляСервера.Свойство("Объект") Тогда
			ВерсияОбъекта = Неопределено;
			Параметры.ЭлементДанныхДляСервера.Свойство("ВерсияОбъекта", ВерсияОбъекта);
			Попытка
				ЭлектроннаяПодпись.ДобавитьПодпись(Параметры.ЭлементДанныхДляСервера.Объект, СвойстваПодписи,
					Параметры.ИдентификаторФормы, ВерсияОбъекта);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ОшибкаНаСервере.Вставить("ОписаниеОшибки", НСтр("ru='При записи подписи возникла ошибка:';uk='При запису підпису виникла помилка:'")
					+ Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				Возврат Ложь;
			КонецПопытки;
		КонецЕсли;
	Иначе
		АдресРезультата = ПоместитьВоВременноеХранилище(ДвоичныеДанныеРезультата, Параметры.ИдентификаторФормы);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Процедура ДобавитьПодпись(СсылкаНаОбъект, СвойстваПодписи, ИдентификаторФормы, ВерсияОбъекта) Экспорт
	
	ЭлектроннаяПодпись.ДобавитьПодпись(СсылкаНаОбъект, СвойстваПодписи, ИдентификаторФормы, ВерсияОбъекта);
	
КонецПроцедуры

// Для функции ВыполнитьНаСторонеСервера.
Функция СертификатыКриптографии(Знач СвойстваСертификатов)
	
	Если ТипЗнч(СвойстваСертификатов) = Тип("Строка") Тогда
		СвойстваСертификатов = ПолучитьИзВременногоХранилища(СвойстваСертификатов);
	КонецЕсли;
	
	Сертификаты = Новый Массив;
	Для каждого Свойства Из СвойстваСертификатов Цикл
		Сертификаты.Добавить(Новый СертификатКриптографии(Свойства.Сертификат));
	КонецЦикла;
	
	Возврат Сертификаты;
	
КонецФункции

#КонецОбласти
