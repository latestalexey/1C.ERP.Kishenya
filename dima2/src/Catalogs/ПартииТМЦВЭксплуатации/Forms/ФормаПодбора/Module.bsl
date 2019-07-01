
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Список.ТекстЗапроса = ТекстЗапросаДинамическогоСписка();
	
	Если Параметры.Свойство("ЗакрыватьПриВыборе") И Параметры.ЗакрыватьПриВыборе=Ложь Тогда
		Элементы.Список.МножественныйВыбор = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ТекущийРегистратор") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Регистратор", Параметры.ТекущийРегистратор);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("Регистратор", Документы.ВнутреннееПотреблениеТоваров.ПустаяСсылка());
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		ОтборОрганизация = Параметры.Организация;
	КонецЕсли;
	Если Параметры.Свойство("Подразделение") Тогда
		ОтборПодразделение = Параметры.Подразделение;
	КонецЕсли;
	Если Параметры.Свойство("ФизическоеЛицо") Тогда
		ОтборФизическоеЛицо = Параметры.ФизическоеЛицо;
	КонецЕсли;
	Если Параметры.Свойство("Дата") Тогда
		ОтборДата = Параметры.Дата;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Дата", КонецДня(ОтборДата));
	Список.Параметры.УстановитьЗначениеПараметра("ДатаУстановлена", ЗначениеЗаполнено(ОтборДата));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Организация", ОтборОрганизация,,, ЗначениеЗаполнено(ОтборОрганизация));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Подразделение", ОтборПодразделение,,, ЗначениеЗаполнено(ОтборПодразделение));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ФизическоеЛицо", ОтборФизическоеЛицо,,, ЗначениеЗаполнено(ОтборФизическоеЛицо));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборНазначенныйРесурсПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "НазначенныйРесурсПревышен", ОтборНазначенныйРесурс=1,,, ЗначениеЗаполнено(ОтборНазначенныйРесурс));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Организация", ОтборОрганизация,,, ЗначениеЗаполнено(ОтборОрганизация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Подразделение", ОтборПодразделение,,, ЗначениеЗаполнено(ОтборПодразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборФизическоеЛицоПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ФизическоеЛицо", ОтборФизическоеЛицо,,, ЗначениеЗаполнено(ОтборФизическоеЛицо));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборДатаПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("Дата", КонецДня(ОтборДата));
	Список.Параметры.УстановитьЗначениеПараметра("ДатаУстановлена", ЗначениеЗаполнено(ОтборДата));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "НазначенныйРесурсПревышен", ОтборНазначенныйРесурс=1,,, ЗначениеЗаполнено(ОтборНазначенныйРесурс));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранныйМассив = Неопределено;
	
	Если Тип("Массив") = ТипЗнч(Значение) Тогда
		ВыбранныйМассив = Значение;
	Иначе
		ВыбранныйМассив = Новый Массив;
		ВыбранныйМассив.Добавить(Значение);
	КонецЕсли;
	
	МассивРезультат = Новый Массив;
	Для Каждого ЭлементМассива Из ВыбранныйМассив Цикл
		
		ТекущиеДанные = Элементы.Список.ДанныеСтроки(ЭлементМассива);
		
		ВыбранноеЗначение = Новый Структура("Номенклатура, Характеристика, ПартияТМЦВЭксплуатации, ФизическоеЛицо, Количество, КоличествоУпаковок");
		
		ЗаполнитьЗначенияСвойств(ВыбранноеЗначение, ТекущиеДанные);
		ВыбранноеЗначение.ПартияТМЦВЭксплуатации = ТекущиеДанные.Партия;
		ВыбранноеЗначение.КоличествоУпаковок = ТекущиеДанные.Количество;
		
		МассивРезультат.Добавить(ВыбранноеЗначение);
	КонецЦикла;
	
	ОповеститьОВыборе(Новый ФиксированныйМассив(МассивРезультат));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаДинамическогоСписка()
	
	Возврат
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Характеристика,
	|	СправочникПартий.Ссылка КАК Партия,
	|	ВложенныйЗапрос.Организация,
	|	ВложенныйЗапрос.Подразделение,
	|	СправочникПартий.Документ,
	|	СправочникПартий.Дата,
	|	СправочникПартий.СрокЭксплуатации,
	|	ВложенныйЗапрос.ФизическоеЛицо,
	|	СправочникПартий.ДатаЗавершенияЭксплуатации,
	|	ВложенныйЗапрос.КоличествоОборот КАК Количество,
	|	ВЫБОР

	|		КОГДА &ДатаУстановлена И СправочникПартий.ДатаЗавершенияЭксплуатации < &Дата
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НазначенныйРесурсПревышен
	|ИЗ
	|	Справочник.ПартииТМЦВЭксплуатации КАК СправочникПартий
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВложенныйЗапрос.Организация КАК Организация,
	|			ВложенныйЗапрос.Подразделение КАК Подразделение,
	|			ВложенныйЗапрос.ФизическоеЛицо КАК ФизическоеЛицо,
	|			ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|			ВложенныйЗапрос.Характеристика КАК Характеристика,
	|			ВложенныйЗапрос.Партия КАК Партия,
	|			СУММА(ВложенныйЗапрос.КоличествоОборот) КАК КоличествоОборот
	|		ИЗ
	|			(ВЫБРАТЬ
	|				ТМЦВЭксплуатацииОбороты.Организация КАК Организация,
	|				ТМЦВЭксплуатацииОбороты.Подразделение КАК Подразделение,
	|				ТМЦВЭксплуатацииОбороты.ФизическоеЛицо КАК ФизическоеЛицо,
	|				ТМЦВЭксплуатацииОбороты.Номенклатура КАК Номенклатура,
	|				ТМЦВЭксплуатацииОбороты.Характеристика КАК Характеристика,
	|				ТМЦВЭксплуатацииОбороты.Партия КАК Партия,
	|				ТМЦВЭксплуатацииОбороты.КоличествоОборот КАК КоличествоОборот
	|			ИЗ
	|				РегистрНакопления.ТМЦВЭксплуатации.Обороты(, &Дата, , ) КАК ТМЦВЭксплуатацииОбороты
	|			
	|			ОБЪЕДИНИТЬ ВСЕ
	|			
	|			ВЫБРАТЬ
	|				ТМЦВЭксплуатации.Организация,
	|				ТМЦВЭксплуатации.Подразделение,
	|				ТМЦВЭксплуатации.ФизическоеЛицо,
	|				ТМЦВЭксплуатации.Номенклатура,
	|				ТМЦВЭксплуатации.Характеристика,
	|				ТМЦВЭксплуатации.Партия,
	|				-ТМЦВЭксплуатации.Количество
	|			ИЗ
	|				РегистрНакопления.ТМЦВЭксплуатации КАК ТМЦВЭксплуатации
	|			ГДЕ
	|				ТМЦВЭксплуатации.Регистратор = &Регистратор
	|				И (НЕ &ДатаУстановлена
	|						ИЛИ ТМЦВЭксплуатации.Период < &Дата)) КАК ВложенныйЗапрос
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВложенныйЗапрос.Организация,
	|			ВложенныйЗапрос.Подразделение,
	|			ВложенныйЗапрос.ФизическоеЛицо,
	|			ВложенныйЗапрос.Номенклатура,
	|			ВложенныйЗапрос.Характеристика,
	|			ВложенныйЗапрос.Партия) КАК ВложенныйЗапрос
	|		ПО СправочникПартий.Ссылка = ВложенныйЗапрос.Партия
	|
	|		
	|ГДЕ
	|	ВложенныйЗапрос.КоличествоОборот > 0";
	
КонецФункции

#КонецОбласти