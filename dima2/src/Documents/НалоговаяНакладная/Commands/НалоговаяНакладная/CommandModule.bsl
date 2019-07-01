
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВозможныеВидыОпераций = ПроверитьДокументОснование(ПараметрКоманды);
	
	ВидОперации = Неопределено;
	Если ВозможныеВидыОпераций.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru='Оформление налоговой накладной на основании документа %ДокументОснование% невозможно.';uk='Оформлення податкової накладної на підставі документа %ДокументОснование% неможливо.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДокументОснование%", ПараметрКоманды);
		ВызватьИсключение ТекстОшибки;
		
	ИначеЕсли ВозможныеВидыОпераций.Количество() = 1 Тогда
		ВидОперации = ВозможныеВидыОпераций[0];
		
	Иначе
		СписокВыбора = Новый СписокЗначений;
		СписокВыбора.ЗагрузитьЗначения(ВозможныеВидыОпераций);
		
		ВыбранныйЭлемент = СписокВыбора.ВыбратьЭлемент(НСтр("ru='Выберите операцию для формирования налоговой накладной';uk='Виберіть операцію для формування податкової накладної'"));
		Если ВыбранныйЭлемент = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ВидОперации = ВыбранныйЭлемент.Значение;
	КонецЕсли;
	
	Основание = Новый Структура("ДокументОснование, ВидОперации", ПараметрКоманды, ВидОперации);
	ПараметрыФормы = Новый Структура("Основание", Основание);
	
	ОткрытьФорму("Документ.НалоговаяНакладная.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьДокументОснование(Основание) Экспорт
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Основание,
		,
		Не Основание.Проведен
	);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР
	|		КОГДА Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыОперацийНалоговыхДокументов.РозницаКонрагентуОсвобожденныеОперации)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыОперацийНалоговыхДокументов.РозницаКонрагентуОблагаемыеОперации)
	|	КОНЕЦ КАК ВидОперации
	|ИЗ
	|	Документ.ЧекККМ.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Основание
	|	И Товары.СтавкаНДС В (
	|		ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС), 
	|		ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20), 
	|		ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС7),
	|		ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0)
	|	)";
	Запрос.УстановитьПараметр("Основание", Основание);
	
	МассивВидовОпераций = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидОперации");
	
	Возврат МассивВидовОпераций;
	
КонецФункции


