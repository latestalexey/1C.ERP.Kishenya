#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает схему для получения факта по статьям бюджетов
// 
// Параметры
// 	 Правило - РегистрСведенийМенеджерЗаписи.ПравилаПолученияФактаПоСтатьямБюджетов, Выборка,
// 				СтрокаТаблицыЗначений, Cтруктура - Правило получения факта по статьям бюджетов.
// 
// Возвращаемое значение
// 	 СхемаКомпоновкиДанных - СхемаКомпоновкиДанных - схема получения фактических данных, соответствующая источнику
//
Функция СхемаПолученияДанных(Правило) Экспорт
	
	СхемаПолученияДанных = ФинансоваяОтчетностьСервер.НоваяСхема();
	НаборДанных = ФинансоваяОтчетностьСервер.НовыйНабор(СхемаПолученияДанных);
	НаборДанных.Запрос =
		"ВЫБРАТЬ
		|*";
	
	Если Правило.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ОперативныйУчет Тогда
		Если ЗначениеЗаполнено(Правило.ИсточникДанных) Тогда
			МакетыИсточниковПолученияДанных = Метаданные.Справочники.ПравилаПолученияФактаПоСтатьямБюджетов.Макеты;
			ИмяИсточникаДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Правило.ИсточникДанных, "ИсточникДанных");
			МакетИсточникаПолученияДанных = МакетыИсточниковПолученияДанных.Найти(ИмяИсточникаДанных);
			Если МакетИсточникаПолученияДанных = Неопределено Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Для операции %1 не определена схема получения данных.';uk='Для операції %1 не визначена схема отримання даних.'"), Правило.ИсточникДанных);
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
			ИмяСхемы = МакетИсточникаПолученияДанных.Имя; 
			СхемаПолученияДанных = Справочники.ПравилаПолученияФактаПоСтатьямБюджетов.ПолучитьМакет(ИмяСхемы);
		КонецЕсли;
	ИначеЕсли Правило.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет Тогда
		ИмяСхемы = "РегламентированныйУчет";
		СхемаПолученияДанных = Справочники.ПравилаПолученияФактаПоСтатьямБюджетов.ПолучитьМакет(ИмяСхемы);
	ИначеЕсли Правило.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет Тогда
		ИмяСхемы = "МеждународныйУчет";
		СхемаПолученияДанных = Справочники.ПравилаПолученияФактаПоСтатьямБюджетов.ПолучитьМакет(ИмяСхемы);
	ИначеЕсли Правило.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные Тогда
		СхемаПолученияДанныхПравила = Правило.СхемаИсточникаДанных.Получить();
		Если СхемаПолученияДанныхПравила <> Неопределено Тогда
			СхемаПолученияДанных = СхемаПолученияДанныхПравила;
		КонецЕсли;
	Иначе
		ВызватьИсключение НСтр("ru='Не определен раздел источника получения данных. Получение схемы невозможно.';uk='Не визначений розділ джерела отримання даних. Отримання схеми неможливо.'");
	КонецЕсли; 
	
	Возврат СхемаПолученияДанных;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	//++ НЕ УТ
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуРезультатРаботыПравилПолученияФактическихДанныхПоСтатьеБюджетов(КомандыОтчетов);
	//-- НЕ УТ

КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

//++ НЕ УТКА

//-- НЕ УТКА

//++ НЕ УТ

//-- НЕ УТ

#КонецОбласти

#КонецЕсли