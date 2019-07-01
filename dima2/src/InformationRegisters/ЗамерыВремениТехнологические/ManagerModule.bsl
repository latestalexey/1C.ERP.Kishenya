#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТопAPDEX(ДатаНачала, ДатаОкончания, ПериодАгрегации, Количество) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если Количество > 0 Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	КлючевыеОперации.Ссылка КАК КлючеваяОперацияСсылка,
		|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя,
		|	КОЛИЧЕСТВО(*) КАК КоличествоЗамеров,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя И Замеры.ВремяВыполнения <= 4 * КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T_4T,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 4 * КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_4T
		|ПОМЕСТИТЬ
		|	Выборка
		|ИЗ
		|	РегистрСведений.ЗамерыВремениТехнологические КАК Замеры
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Справочник.КлючевыеОперации КАК КлючевыеОперации
		|ПО
		|	Замеры.КлючеваяОперация = КлючевыеОперации.Ссылка
		|ГДЕ
		|	Замеры.ДатаНачалаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	КлючевыеОперации.Ссылка,
		|	КлючевыеОперации.ЦелевоеВремя
		|;
		|ВЫБРАТЬ
		|	СУММА(КоличествоЗамеров) КАК КоличествоЗамеров
		|ПОМЕСТИТЬ
		|	ВсегоЗамеров
		|ИЗ
		|	Выборка
		|;
		|ВЫБРАТЬ ПЕРВЫЕ %Количество
		|	Выборка.КлючеваяОперацияСсылка,
		|	Выборка.ЦелевоеВремя,
		|	Выборка.КоличествоЗамеров,
		|	Выборка.N_T,
		|	Выборка.N_T_4T,
		|	Выборка.N_4T,
		|	ВЫРАЗИТЬ((Выборка.N_T + Выборка.N_T_4T/2)/Выборка.КоличествоЗамеров КАК ЧИСЛО(15,3)) КАК APDEX,
		|	ВЫРАЗИТЬ((Выборка.N_4T + Выборка.N_T_4T/2)/ВсегоЗамеров.КоличествоЗамеров КАК ЧИСЛО(15,3)) КАК APDEXВлияние
		|ПОМЕСТИТЬ
		|	ВыборкаХудшиеОперации
		|ИЗ
		|	Выборка
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	ВсегоЗамеров
		|ПО
		|	НЕ ВсегоЗамеров.КоличествоЗамеров IS NULL
		|УПОРЯДОЧИТЬ ПО
		|	(Выборка.N_4T + Выборка.N_T_4T/2)/ВсегоЗамеров.КоличествоЗамеров УБЫВ
		|;
		|";
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
		Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%Количество", Формат(Количество, "ЧН=0; ЧГ="));
		Запрос.Выполнить();
		
		РассчитатьСтатистикуОпераций(Запрос, ДатаНачала, ДатаОкончания, ПериодАгрегации);

		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200) КАК Период,
		|	СпрКлючевыеОперации.Наименование КАК КлючеваяОперация,
		|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя И Замеры.ВремяВыполнения <= 4 * КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T_4T,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 4 * КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_4T,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения <= 0.5 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_0_5,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 0.5 И Замеры.ВремяВыполнения <= 1 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_1,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 1 И Замеры.ВремяВыполнения <= 2 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_2,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 2 И Замеры.ВремяВыполнения <= 3 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_3,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 3 И Замеры.ВремяВыполнения <= 4 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_4,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 4 И Замеры.ВремяВыполнения <= 5 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_5,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 5 И Замеры.ВремяВыполнения <= 6 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_6,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 6 И Замеры.ВремяВыполнения <= 7 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_7,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 7 И Замеры.ВремяВыполнения <= 8 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_8,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 8 И Замеры.ВремяВыполнения <= 9 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_9,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 9 И Замеры.ВремяВыполнения <= 10 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_10,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 10 И Замеры.ВремяВыполнения <= 11 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_11,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 11 И Замеры.ВремяВыполнения <= 12 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_12,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 12 И Замеры.ВремяВыполнения <= 13 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_13,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 13 И Замеры.ВремяВыполнения <= 14 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_14,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 14 И Замеры.ВремяВыполнения <= 15 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_15,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 15 И Замеры.ВремяВыполнения <= 16 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_16,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 16 И Замеры.ВремяВыполнения <= 17 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_17,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 17 И Замеры.ВремяВыполнения <= 18 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_18,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 18 И Замеры.ВремяВыполнения <= 19 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_19,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 19 И Замеры.ВремяВыполнения <= 20 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_20,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 20 И Замеры.ВремяВыполнения <= 30 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_30,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 30 И Замеры.ВремяВыполнения <= 60 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_60,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 60 И Замеры.ВремяВыполнения <= 300 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_300,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 300 И Замеры.ВремяВыполнения <= 600 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_600,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 600 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_MORE_600,
		|	ТаблицаСтатистики.Максимум КАК ВремяВыполненияМаксимум,
		|	ТаблицаСтатистики.Медиана КАК ВремяВыполненияМедиана,
		|	ТаблицаСтатистики.Минимум КАК ВремяВыполненияМинимум,
		|	ТаблицаСтатистики.Среднее КАК ВремяВыполненияСреднее,
		|	ТаблицаСтатистики.СтандартноеОтклонение КАК ВремяВыполненияСтандартноеОтклонение,
		|	ТаблицаСтатистики.КоличествоОпераций КАК КоличествоОпераций,
		|	ТаблицаСтатистики.Максимум90 КАК ВремяВыполненияМаксимум90,
		|	ТаблицаСтатистики.Медиана90 КАК ВремяВыполненияМедиана90,
		|	ТаблицаСтатистики.Минимум90 КАК ВремяВыполненияМинимум90,
		|	ТаблицаСтатистики.Среднее90 КАК ВремяВыполненияСреднее90,
		|	ТаблицаСтатистики.СтандартноеОтклонение90 КАК ВремяВыполненияСтандартноеОтклонение90,
		|	ТаблицаСтатистики.КоличествоОпераций90 КАК КоличествоОпераций90
		|ИЗ
		|	РегистрСведений.ЗамерыВремениТехнологические КАК Замеры
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	ВыборкаХудшиеОперации КАК КлючевыеОперации
		|ПО
		|	Замеры.КлючеваяОперация = КлючевыеОперации.КлючеваяОперацияСсылка
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Справочник.КлючевыеОперации КАК СпрКлючевыеОперации
		|ПО
		|	Замеры.КлючеваяОперация = СпрКлючевыеОперации.Ссылка
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	ТаблицаСтатистики КАК ТаблицаСтатистики
		|ПО
		|	ТаблицаСтатистики.КлючеваяОперация = Замеры.КлючеваяОперация
		|	И ТаблицаСтатистики.Период = ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200)
		|ГДЕ
		|	Замеры.ДатаНачалаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200),
		|	СпрКлючевыеОперации.Наименование,
		|	КлючевыеОперации.ЦелевоеВремя,
		|	ТаблицаСтатистики.Максимум,
		|	ТаблицаСтатистики.Медиана,
		|	ТаблицаСтатистики.Минимум,
		|	ТаблицаСтатистики.Среднее,
		|	ТаблицаСтатистики.СтандартноеОтклонение,
		|	ТаблицаСтатистики.КоличествоОпераций,
		|	ТаблицаСтатистики.Максимум90,
		|	ТаблицаСтатистики.Медиана90,
		|	ТаблицаСтатистики.Минимум90,
		|	ТаблицаСтатистики.Среднее90,
		|	ТаблицаСтатистики.СтандартноеОтклонение90,
		|	ТаблицаСтатистики.КоличествоОпераций90
		|УПОРЯДОЧИТЬ ПО
		|   ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200)
		|;";
		
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
		Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации);
	Иначе
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Замеры.КлючеваяОперация КАК КлючеваяОперацияСсылка
		|ПОМЕСТИТЬ
		|	ВыборкаХудшиеОперации
		|ИЗ
		|	РегистрСведений.ЗамерыВремениТехнологические КАК Замеры
		|ГДЕ
		|	Замеры.ДатаНачалаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
		|";
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
		
		Запрос.Выполнить();
		
		РассчитатьСтатистикуОпераций(Запрос, ДатаНачала, ДатаОкончания, ПериодАгрегации);
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200) КАК Период,
		|	СпрКлючевыеОперации.Наименование КАК КлючеваяОперация,
		|	СпрКлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения <= СпрКлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения > СпрКлючевыеОперации.ЦелевоеВремя И Замеры.ВремяВыполнения <= 4 * СпрКлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T_4T,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения > 4 * СпрКлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_4T,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения <= 0.5 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_0_5,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 0.5 И Замеры.ВремяВыполнения <= 1 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_1,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 1 И Замеры.ВремяВыполнения <= 2 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_2,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 2 И Замеры.ВремяВыполнения <= 3 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_3,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 3 И Замеры.ВремяВыполнения <= 4 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_4,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 4 И Замеры.ВремяВыполнения <= 5 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_5,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 5 И Замеры.ВремяВыполнения <= 6 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_6,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 6 И Замеры.ВремяВыполнения <= 7 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_7,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 7 И Замеры.ВремяВыполнения <= 8 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_8,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 8 И Замеры.ВремяВыполнения <= 9 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_9,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 9 И Замеры.ВремяВыполнения <= 10 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_10,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 10 И Замеры.ВремяВыполнения <= 11 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_11,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 11 И Замеры.ВремяВыполнения <= 12 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_12,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 12 И Замеры.ВремяВыполнения <= 13 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_13,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 13 И Замеры.ВремяВыполнения <= 14 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_14,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 14 И Замеры.ВремяВыполнения <= 15 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_15,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 15 И Замеры.ВремяВыполнения <= 16 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_16,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 16 И Замеры.ВремяВыполнения <= 17 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_17,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 17 И Замеры.ВремяВыполнения <= 18 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_18,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 18 И Замеры.ВремяВыполнения <= 19 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_19,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 19 И Замеры.ВремяВыполнения <= 20 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_20,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 20 И Замеры.ВремяВыполнения <= 30 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_30,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 30 И Замеры.ВремяВыполнения <= 60 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_60,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 60 И Замеры.ВремяВыполнения <= 300 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_300,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 300 И Замеры.ВремяВыполнения <= 600 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_600,
		|	СУММА(ВЫБОР
		|			КОГДА Замеры.ВремяВыполнения > 600 ТОГДА 1
		|			ИНАЧЕ 0
		|	КОНЕЦ) КАК N_MORE_600,
		|	ТаблицаСтатистики.Максимум КАК ВремяВыполненияМаксимум,
		|	ТаблицаСтатистики.Медиана КАК ВремяВыполненияМедиана,
		|	ТаблицаСтатистики.Минимум КАК ВремяВыполненияМинимум,
		|	ТаблицаСтатистики.Среднее КАК ВремяВыполненияСреднее,
		|	ТаблицаСтатистики.СтандартноеОтклонение КАК ВремяВыполненияСтандартноеОтклонение,
		|	ТаблицаСтатистики.КоличествоОпераций КАК КоличествоОпераций,
		|	ТаблицаСтатистики.Максимум90 КАК ВремяВыполненияМаксимум90,
		|	ТаблицаСтатистики.Медиана90 КАК ВремяВыполненияМедиана90,
		|	ТаблицаСтатистики.Минимум90 КАК ВремяВыполненияМинимум90,
		|	ТаблицаСтатистики.Среднее90 КАК ВремяВыполненияСреднее90,
		|	ТаблицаСтатистики.СтандартноеОтклонение90 КАК ВремяВыполненияСтандартноеОтклонение90,
		|	ТаблицаСтатистики.КоличествоОпераций90 КАК КоличествоОпераций90
		|ИЗ
		|	РегистрСведений.ЗамерыВремениТехнологические КАК Замеры
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Справочник.КлючевыеОперации КАК СпрКлючевыеОперации
		|ПО
		|	Замеры.КлючеваяОперация = СпрКлючевыеОперации.Ссылка
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	ТаблицаСтатистики КАК ТаблицаСтатистики
		|ПО
		|	ТаблицаСтатистики.КлючеваяОперация = Замеры.КлючеваяОперация
		|	И ТаблицаСтатистики.Период = ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200)
		|ГДЕ
		|	Замеры.ДатаНачалаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200),
		|	СпрКлючевыеОперации.Наименование,
		|	СпрКлючевыеОперации.ЦелевоеВремя,
		|	ТаблицаСтатистики.Максимум,
		|	ТаблицаСтатистики.Медиана,
		|	ТаблицаСтатистики.Минимум,
		|	ТаблицаСтатистики.Среднее,
		|	ТаблицаСтатистики.СтандартноеОтклонение,
		|	ТаблицаСтатистики.КоличествоОпераций,
		|	ТаблицаСтатистики.Максимум90,
		|	ТаблицаСтатистики.Медиана90,
		|	ТаблицаСтатистики.Минимум90,
		|	ТаблицаСтатистики.Среднее90,
		|	ТаблицаСтатистики.СтандартноеОтклонение90,
		|	ТаблицаСтатистики.КоличествоОпераций90
		|УПОРЯДОЧИТЬ ПО
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200)
		|;";
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
		Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации);
	КонецЕсли;
		
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
КонецФункции

Процедура РассчитатьСтатистикуОпераций(Запрос, ДатаНачала, ДатаОкончания, ПериодАгрегации)
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	КлючеваяОперацияСсылка
	|ИЗ
	|	ВыборкаХудшиеОперации КАК КлючевыеОперации
	|";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗапросСтатистики = Новый Запрос;
	ЗапросСтатистики.Текст = "
	|ВЫБРАТЬ
	|	ВремяВыполнения
	|ИЗ
	|	РегистрСведений.ЗамерыВремени КАК Замеры
	|ГДЕ
	|	Замеры.КлючеваяОперация = &КлючеваяОперация
	|	И Замеры.ДатаНачалаЗамера >= &ДатаНачала
	|	И Замеры.ДатаНачалаЗамера < &ДатаОкончания
	|УПОРЯДОЧИТЬ ПО
	|	ВремяВыполнения
	|";
	
	ТаблицаСтатистики = ТаблицаСтатистикиИнициализировать();
		
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДатаНачалаЦикла = ДатаНачала;
		Пока ДатаНачалаЦикла < ДатаОкончания Цикл
			ЗапросСтатистики.УстановитьПараметр("КлючеваяОперация", Выборка.КлючеваяОперацияСсылка);
			ЗапросСтатистики.УстановитьПараметр("ДатаНачала", ДатаНачалаЦикла);
			ЗапросСтатистики.УстановитьПараметр("ДатаОкончания", ДатаНачалаЦикла + ПериодАгрегации);
			
			РезультатЗапросаСтатистики = ЗапросСтатистики.Выполнить();
			ТаблицаСтатистикиПолная = РезультатЗапросаСтатистики.Выгрузить();
			РезультатЗапросаСтатистики = Неопределено;
			
			РезультатАнализа = ПровестиАнализДанных(ТаблицаСтатистикиПолная);
			КоличествоУдалить = Цел(ТаблицаСтатистикиПолная.Количество() * 0.05/2);
			
			Для ТекКоличествоУдалить = 1 По КоличествоУдалить Цикл
				ТаблицаСтатистикиПолная.Удалить(0);
				ТаблицаСтатистикиПолная.Удалить(ТаблицаСтатистикиПолная.Количество() - 1);
			КонецЦикла;
			РезультатАнализа90 = ПровестиАнализДанных(ТаблицаСтатистикиПолная);
						
			НоваяСтрока = ТаблицаСтатистики.Добавить();
			НоваяСтрока.Период = ДатаНачалаЦикла;
			НоваяСтрока.КлючеваяОперация = Выборка.КлючеваяОперацияСсылка;
			
			НоваяСтрока.КоличествоОпераций = РезультатАнализа.КоличествоОпераций;
			НоваяСтрока.Максимум = РезультатАнализа.Максимум;
			НоваяСтрока.Медиана = РезультатАнализа.Медиана;
			НоваяСтрока.Минимум = РезультатАнализа.Минимум;
			НоваяСтрока.Среднее = РезультатАнализа.Среднее;
			НоваяСтрока.СтандартноеОтклонение = РезультатАнализа.СтандартноеОтклонение;
			
			НоваяСтрока.КоличествоОпераций90 = РезультатАнализа90.КоличествоОпераций;
			НоваяСтрока.Максимум90 = РезультатАнализа90.Максимум;
			НоваяСтрока.Медиана90 = РезультатАнализа90.Медиана;
			НоваяСтрока.Минимум90 = РезультатАнализа90.Минимум;
			НоваяСтрока.Среднее90 = РезультатАнализа90.Среднее;
			НоваяСтрока.СтандартноеОтклонение90 = РезультатАнализа90.СтандартноеОтклонение;
			
			ДатаНачалаЦикла = ДатаНачалаЦикла + ПериодАгрегации;			
			
		КонецЦикла;
	КонецЦикла;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	*
	|ПОМЕСТИТЬ
	|	ТаблицаСтатистики
	|ИЗ
	|	&ТаблицаСтатистики КАК ТаблицаСтатистики
	|";
	
	Запрос.УстановитьПараметр("ТаблицаСтатистики", ТаблицаСтатистики);
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПровестиАнализДанных(Данные)
	
	АнализДанных = Новый АнализДанных;
	АнализДанных.ТипАнализа = Тип("АнализДанныхОбщаяСтатистика");
	АнализДанных.ИсточникДанных = Данные;
		
	РезультатАнализа = АнализДанных.Выполнить();
	
	Результат = Новый Структура("КоличествоОпераций, Максимум, Медиана, Минимум, Среднее, СтандартноеОтклонение");
	Если РезультатАнализа.НепрерывныеПоля.Количество() = 1 Тогда
		ДанныеПоКлючевойОперации = РезультатАнализа.НепрерывныеПоля[0];
		Результат.КоличествоОпераций = ДанныеПоКлючевойОперации.Количество;
		Результат.Максимум = ДанныеПоКлючевойОперации.Максимум;
		Результат.Медиана = ДанныеПоКлючевойОперации.Медиана;
		Результат.Минимум = ДанныеПоКлючевойОперации.Минимум;
		Результат.Среднее = ДанныеПоКлючевойОперации.Среднее;
		Результат.СтандартноеОтклонение = ДанныеПоКлючевойОперации.СтандартноеОтклонение;
	Иначе
		Результат.КоличествоОпераций = 0;
		Результат.Максимум = 0;
		Результат.Медиана = 0;
		Результат.Минимум = 0;
		Результат.Среднее = 0;
		Результат.СтандартноеОтклонение = 0;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаСтатистикиИнициализировать()
	
	ТаблицаСтатистики = Новый ТаблицаЗначений;
	ТаблицаСтатистики.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата",,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТаблицаСтатистики.Колонки.Добавить("КлючеваяОперация", Новый ОписаниеТипов("СправочникСсылка.КлючевыеОперации"));
	
	ТаблицаСтатистики.Колонки.Добавить("КоличествоОпераций", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("Максимум", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("Медиана", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("Минимум", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("Среднее", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("СтандартноеОтклонение", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	
	ТаблицаСтатистики.Колонки.Добавить("КоличествоОпераций90", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("Максимум90", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("Медиана90", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("Минимум90", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("Среднее90", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));
	ТаблицаСтатистики.Колонки.Добавить("СтандартноеОтклонение90", Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(15,3)));

	
	Возврат ТаблицаСтатистики;
	
КонецФункции

#КонецОбласти

#КонецЕсли