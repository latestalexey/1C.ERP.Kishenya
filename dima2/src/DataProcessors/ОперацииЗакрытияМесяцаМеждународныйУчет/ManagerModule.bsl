#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет последовательно регламентные операции по закрытию месяца,
// которые могут быть выполнены в автоматическом режиме.
//
Процедура ВыполнитьОперацииПоЗакрытиюМесяца(Организация, ПериодРегистрации) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет") Тогда
		НачислитьАмортизациюОС(ПериодРегистрации, Организация);
		НачислитьАмортизациюНМА(ПериодРегистрации, Организация);
	КонецЕсли;
	
	ПроводкиПоДаннымОперУчета = ПолучитьФункциональнуюОпцию("ФормироватьПроводкиМеждународногоУчетаПоДаннымОперативного");
	ПроводкиПоДаннымРеглУчета = ПолучитьФункциональнуюОпцию("ФормироватьПроводкиМеждународногоУчетаПоДаннымРегламентированного");
	Если ПроводкиПоДаннымОперУчета ИЛИ ПроводкиПоДаннымРеглУчета Тогда
		МеждународныйУчетПроведениеСервер.ОтразитьВМеждународномУчете(Организация, КонецМесяца(ПериодРегистрации));
	КонецЕсли;
	РасчетКурсовыхРазниц(Организация, ПериодРегистрации);
	ЗакрытиеСчетовДоходовРасходов(Организация, ПериодРегистрации);
	
	УчетнаяВалюта = МеждународнаяОтчетностьВызовСервера.УчетнаяВалюта();
	Если УчетнаяВалюта.Функциональная <> УчетнаяВалюта.Представления Тогда
		ПересчетВВалютуПредставления(Организация, ПериодРегистрации);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет расчет и начисление амортизации ОС посредством ввода(перепроведения) соотвествующих документов.
Процедура НачислитьАмортизациюОС(ПериодРегистрации, Организация = Неопределено) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОС.Организация
	|ПОМЕСТИТЬ Организации
	|ИЗ
	|	РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(&КонецПериода, 
	|		Организация = &Организация
	|			ИЛИ &ПоВсемОрганизациям
	|	) КАК ОС
	|ГДЕ
	|	ОС.Состояние = &Состояние
	|	И ОС.ПорядокУчета = &ПорядокУчета
	|СГРУППИРОВАТЬ ПО
	|	ОС.Организация
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Организация,
	|	ЕСТЬNULL(АмортизацияОС.Ссылка, ЗНАЧЕНИЕ(Документ.АмортизацияОСМеждународныйУчет.ПустаяСсылка)) КАК Ссылка,
	|	""АмортизацияОС"" КАК ТипОперации
	|ИЗ
	|	Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.АмортизацияОСМеждународныйУчет КАК АмортизацияОС
	|	ПО Организации.Организация = АмортизацияОС.Организация
	|		И (АмортизацияОС.Дата >= &НачалоПериода)
	|		И (АмортизацияОС.Дата <= &КонецПериода)");
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", НЕ ЗначениеЗаполнено(Организация));
	Запрос.УстановитьПараметр("Состояние", Перечисления.СостоянияОС.ПринятоКУчету);
	Запрос.УстановитьПараметр("ПорядокУчета", Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию);
	
	СоздатьПерепровестиДокументы(Запрос);
	
КонецПроцедуры

// Выполняет расчет и начисление амортизации НМА посредством ввода(перепроведения) соотвествующих документов.
Процедура НачислитьАмортизациюНМА(ПериодРегистрации, Организация = Неопределено) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НМА.Организация
	|ПОМЕСТИТЬ Организации
	|ИЗ
	|	РегистрСведений.НематериальныеАктивыМеждународныйУчет.СрезПоследних(
	|		&КонецПериода,
	|		Организация = &Организация
	|			ИЛИ &ПоВсемОрганизациям
	|	) КАК НМА
	|ГДЕ
	|	НМА.Состояние = &Состояние
	|	И НМА.ПорядокУчета = &ПорядокУчета
	|СГРУППИРОВАТЬ ПО
	|	НМА.Организация
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Организация,
	|	ЕСТЬNULL(АмортизацияНМА.Ссылка, ЗНАЧЕНИЕ(Документ.АмортизацияНМАМеждународныйУчет.ПустаяСсылка)) КАК Ссылка,
	|	""АмортизацияНМА"" КАК ТипОперации
	|ИЗ
	|	Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.АмортизацияНМАМеждународныйУчет КАК АмортизацияНМА
	|	ПО Организации.Организация = АмортизацияНМА.Организация
	|		И (АмортизацияНМА.Дата >= &НачалоПериода)
	|		И (АмортизацияНМА.Дата <= &КонецПериода)");
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", НЕ ЗначениеЗаполнено(Организация));
	Запрос.УстановитьПараметр("Состояние", Перечисления.ВидыСостоянийНМА.ПринятКУчету);
	Запрос.УстановитьПараметр("ПорядокУчета", Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию);
	
	СоздатьПерепровестиДокументы(Запрос);
	
КонецПроцедуры

// Выполняет для заданной организации за указанный месяц ввод документов РасчетКурсовыхРазницФункциональнаяВалюта.
// Существующие документы перепроводятся.
Процедура РасчетКурсовыхРазниц(Организация, ПериодРегистрации) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УчетнаяПолитикаОрганизацийМУСрезПоследних.Организация
	|ПОМЕСТИТЬ Организации
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета.СрезПоследних(
	|			&КонецПериода,
	|			Организация = &Организация
	|				ИЛИ &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК УчетнаяПолитикаОрганизацийМУСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Организации.Организация,
	|	ЕСТЬNULL(РасчетКурсовыхРазниц.Ссылка, ЗНАЧЕНИЕ(Документ.РегламентнаяОперацияМеждународныйУчет.ПустаяСсылка)) КАК Ссылка,
	|	""РасчетКурсовыхРазницФункциональнаяВалюта"" КАК ТипОперации,
	|	РасчетКурсовыхРазниц.Дата КАК Дата
	|ИЗ
	|	Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РегламентнаяОперацияМеждународныйУчет КАК РасчетКурсовыхРазниц
	|		ПО Организации.Организация = РасчетКурсовыхРазниц.Организация
	|			И (РасчетКурсовыхРазниц.Дата >= &НачалоПериода)
	|			И (РасчетКурсовыхРазниц.Дата <= &КонецПериода)
	|			И (РасчетКурсовыхРазниц.ТипОперации = ЗНАЧЕНИЕ(Перечисление.ТипыРегламентныхОперацийМеждународныйУчет.РасчетКурсовыхРазницФункциональнаяВалюта))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ");
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(КонецМесяца(ПериодРегистрации)));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	СоздатьПерепровестиДокументы(Запрос);
	
КонецПроцедуры

// Выполняет для заданной организации за указанный месяц ввод документов РегламентнаяОперацияМеждународныйУчет.
// Существующие документы перепроводятся.
Процедура ЗакрытиеСчетовДоходовРасходов(Организация, ПериодРегистрации) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УчетнаяПолитикаОрганизацийМУСрезПоследних.Организация
	|ПОМЕСТИТЬ Организации
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета.СрезПоследних(
	|			&КонецПериода,
	|			Организация = &Организация
	|				ИЛИ &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК УчетнаяПолитикаОрганизацийМУСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Организация,
	|	ЕСТЬNULL(ЗакрытиеСчетовДоходовРасходовМУ.Ссылка, ЗНАЧЕНИЕ(Документ.РегламентнаяОперацияМеждународныйУчет.ПустаяСсылка)) КАК Ссылка,
	|	""ЗакрытиеСчетовДоходовРасходов"" КАК ТипОперации
	|ИЗ
	|	Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РегламентнаяОперацияМеждународныйУчет КАК ЗакрытиеСчетовДоходовРасходовМУ
	|		ПО Организации.Организация = ЗакрытиеСчетовДоходовРасходовМУ.Организация
	|			И (ЗакрытиеСчетовДоходовРасходовМУ.Дата >= &НачалоПериода)
	|			И (ЗакрытиеСчетовДоходовРасходовМУ.Дата <= &КонецПериода)
	|			И (ЗакрытиеСчетовДоходовРасходовМУ.ТипОперации = ЗНАЧЕНИЕ(Перечисление.ТипыРегламентныхОперацийМеждународныйУчет.ЗакрытиеСчетовДоходовРасходов))
	|");
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	СоздатьПерепровестиДокументы(Запрос);
	
КонецПроцедуры

// Выполняет для заданной организации за указанный месяц ввод документов ПересчетВВалютуПредставленияМеждународныйУчет.
// Существующие документы перепроводятся.
Процедура ПересчетВВалютуПредставления(Организация, ПериодРегистрации) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УчетнаяПолитикаОрганизацийМУСрезПоследних.Организация
	|ПОМЕСТИТЬ Организации
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета.СрезПоследних(
	|			&КонецПериода,
	|			Организация = &Организация
	|				ИЛИ &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК УчетнаяПолитикаОрганизацийМУСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Организации.Организация,
	|	ЕСТЬNULL(ПересчетВВлютуПредставления.Ссылка, ЗНАЧЕНИЕ(Документ.РегламентнаяОперацияМеждународныйУчет.ПустаяСсылка)) КАК Ссылка,
	|	""РасчетКурсовыхРазницВалютаПредставления"" КАК ТипОперации,
	|	ПересчетВВлютуПредставления.Дата КАК Дата
	|ИЗ
	|	Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РегламентнаяОперацияМеждународныйУчет КАК ПересчетВВлютуПредставления
	|		ПО Организации.Организация = ПересчетВВлютуПредставления.Организация
	|			И (ПересчетВВлютуПредставления.Дата >= &НачалоПериода)
	|			И (ПересчетВВлютуПредставления.Дата <= &КонецПериода)
	|			И (ПересчетВВлютуПредставления.ТипОперации = ЗНАЧЕНИЕ(Перечисление.ТипыРегламентныхОперацийМеждународныйУчет.РасчетКурсовыхРазницВалютаПредставления))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ");
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(КонецМесяца(ПериодРегистрации)));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	СоздатьПерепровестиДокументы(Запрос);
	
КонецПроцедуры

// Получает состояние отражения документов в международном учете
//
// Параметры:
//  СписокДоступныхОрганизаций  - <массив>, <СправочникСсылка.Организации> - Организации по которым необходимо 
//                                получить отражения состояние документов в международном учете
//  ПериодРегистрации  - <Дата> - дата месяца в котором необходимо определить отражения состояние документов в международном учете
//
// Возвращаемое значение:
//   <Перечисления.СостоянияОперацийЗакрытияМесяца> - одно из состояний документов в международном учете
//
Функция СостояниеОтражениеДокументов(Организация, ПериодРегистрации) Экспорт

	Запрос = новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтражениеДокументов.Период КАК Период,
	|	ОтражениеДокументов.Регистратор КАК Регистратор,
	|	ОтражениеДокументов.Статус КАК Статус
	|ПОМЕСТИТЬ ОтражениеДокументов
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВМеждународномУчете КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Организация В (&Организация)
	|	И ОтражениеДокументов.Период <= &ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ОтражениеДокументов.Период) КАК ДатаНачала,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтражениеДокументов.Регистратор) КАК Количество
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчете)
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МИНИМУМ(ОтражениеДокументов.Период) КАК ДатаНачала,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтражениеДокументов.Регистратор) КАК Количество
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчетеВРучную)
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ОтражениеДокументов.Период) КАК ДатаНачала,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтражениеДокументов.Регистратор) КАК Количество
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.ОтсутствуютПравилаОтраженияВУчете)
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) > 0
	|;
	|";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаОкончания", ?(ЗначениеЗаполнено(ПериодРегистрации), КонецМесяца(ПериодРегистрации), Дата(2399, 1, 1)));
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.ВыполнитьПакет();
	
	Если Результат[1].Пустой() И Результат[2].Пустой() Тогда
		Возврат Перечисления.СостоянияОперацийЗакрытияМесяца.ВыполненоУспешно;
	КонецЕсли;
	
	Возврат Перечисления.СостоянияОперацийЗакрытияМесяца.НеВыполнено;

КонецФункции // СостояниеОтражениеДокументов()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьПерепровестиДокументы(Запрос)
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	ДатаДокумента = Запрос.Параметры.КонецПериода;
	ТипыОпераций = Перечисления.ТипыРегламентныхОперацийМеждународныйУчет;
	Пока Выборка.Следующий() Цикл
		Если Выборка.Ссылка.Пустая() Тогда
			Если Выборка.ТипОперации = "АмортизацияОС" Тогда
				ДокументОбъект = Документы.АмортизацияОСМеждународныйУчет.СоздатьДокумент();
			ИначеЕсли Выборка.ТипОперации = "АмортизацияНМА" Тогда
				ДокументОбъект = Документы.АмортизацияНМАМеждународныйУчет.СоздатьДокумент();
			ИначеЕсли Выборка.ТипОперации = "РасчетКурсовыхРазницФункциональнаяВалюта" Тогда
				ДокументОбъект = Документы.РегламентнаяОперацияМеждународныйУчет.СоздатьДокумент();
				ДокументОбъект.ТипОперации = ТипыОпераций.РасчетКурсовыхРазницФункциональнаяВалюта;
			ИначеЕсли Выборка.ТипОперации = "ЗакрытиеСчетовДоходовРасходов" Тогда
				ДокументОбъект = Документы.РегламентнаяОперацияМеждународныйУчет.СоздатьДокумент();
				ДокументОбъект.ТипОперации = ТипыОпераций.ЗакрытиеСчетовДоходовРасходов;
			ИначеЕсли Выборка.ТипОперации = "РасчетКурсовыхРазницВалютаПредставления" Тогда
				ДокументОбъект = Документы.РегламентнаяОперацияМеждународныйУчет.СоздатьДокумент();
				ДокументОбъект.ТипОперации = ТипыОпераций.РасчетКурсовыхРазницВалютаПредставления;
			КонецЕсли;
		Иначе
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.ПометкаУдаления = Ложь;
			Если ДокументОбъект.Проведен Тогда
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			КонецЕсли;
		КонецЕсли;
		ДокументОбъект.Организация = Выборка.Организация;
		ДокументОбъект.Дата = ДатаДокумента;
		ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
		ДокументМетаданные = ДокументОбъект.Метаданные();
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ЗаписьЖурналаРегистрации("ЗакрытиеМесяцаМеждународныйУчет", УровеньЖурналаРегистрации.Ошибка,,,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли