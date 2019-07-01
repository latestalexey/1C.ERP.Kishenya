#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.Вставить("РазрешеноМенятьВарианты", Ложь);
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	ЭтаФорма.РежимВариантаОтчета = Ложь;
КонецПроцедуры

#КонецОбласти
	
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ВнешниеНаборыДанных = СформироватьВнешниеНаборыДанных(НастройкиОсновнойСхемы);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);	
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьВнешниеНаборыДанных(НастройкиОсновнойСхемы)
	
	Документ = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Документ").Значение;
	Номенклатура = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Номенклатура").Значение;
	Характеристика = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Характеристика").Значение;
	ВариантОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "ВариантОтчета").Значение;
	
	Если ВариантОтчета = "ПередачаСырьяПереработчику" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаТовары.Ссылка КАК Документ,
		|	ТаблицаТовары.Количество КАК Количество
		|ИЗ
		|	Документ.ПередачаСырьяПереработчику КАК ТаблицаДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаСырьяПереработчику.Товары КАК ТаблицаТовары
		|		ПО ТаблицаДокумента.Ссылка = ТаблицаТовары.Ссылка
		|ГДЕ
		|	ТаблицаДокумента.ЗаказПереработчику = &Заказ
		|	И ТаблицаДокумента.Проведен
		|	И ТаблицаТовары.Номенклатура = &Номенклатура
		|	И ТаблицаТовары.Характеристика = &Характеристика
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТаблицаТовары.Ссылка КАК Документ,
		|	-ТаблицаТовары.Количество КАК Количество
		|ИЗ
		|	Документ.ВозвратСырьяОтПереработчика КАК ТаблицаДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратСырьяОтПереработчика.Товары КАК ТаблицаТовары
		|		ПО ТаблицаДокумента.Ссылка = ТаблицаТовары.Ссылка
		|ГДЕ
		|	ТаблицаДокумента.ЗаказПереработчику = &Заказ
		|	И ТаблицаДокумента.Проведен
		|	И ТаблицаТовары.Номенклатура = &Номенклатура
		|	И ТаблицаТовары.Характеристика = &Характеристика";
		
	Иначе
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаТовары.Ссылка КАК Документ,
		|	ТаблицаТовары.Количество КАК Количество
		|ИЗ
		|	Документ.ПоступлениеОтПереработчика КАК ТаблицаДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеОтПереработчика.Товары КАК ТаблицаТовары
		|		ПО ТаблицаДокумента.Ссылка = ТаблицаТовары.Ссылка
		|ГДЕ
		|	ТаблицаДокумента.ЗаказПереработчику = &Заказ
		|	И ТаблицаДокумента.Проведен
		|	И ТаблицаТовары.Номенклатура = &Номенклатура
		|	И ТаблицаТовары.Характеристика = &Характеристика";
		
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Заказ", Документ);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	
	СписокДокументов = Запрос.Выполнить().Выгрузить();
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("СписокДокументов", СписокДокументов);
	
	Возврат ВнешниеНаборыДанных;

КонецФункции

#КонецОбласти

#КонецЕсли
