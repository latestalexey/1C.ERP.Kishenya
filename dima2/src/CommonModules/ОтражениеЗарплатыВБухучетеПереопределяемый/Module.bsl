////////////////////////////////////////////////////////////////////////////////
// Отражение зарплаты в регламентированном учёте
// Переопределяемое в потребителе поведение
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция предназначена для вычисления процента ЕНВД в текущем месяце по данным бухгалтерского учета
// 
//
//	Параметры:
//	- Организация, тип СправочникСсылка.Организации,
//	- ПериодРегистрации, тип дата, состав дата
//
//	Возвращаемое значение
//		Число или Неопределено
//
Функция ПроцентЕНВД(Организация, ПериодРегистрации) Экспорт
	
	Возврат Неопределено;
		
КонецФункции

// Процедура предназначена для формирования движений по бухучету.
//
// Параметры:
//	Движения - Коллекция движений документа, 
//	Отказ - булево, признак отказа от проведения документа.
//	Организация
//	МесяцНачисления - тип Дата, месяц, зарплата которого отражается в бухучете.
//	ДанныеДляОтражения - структура. Таблицы значений с данными, которые 
//						могут использоваться для формирования движений по бухучету.
//						При вызове процедуры ДанныеДляОтражения может содержать 
//						одно или несколько полей с приведенными ниже именами, т.е.
//						Необходимо проверять наличие того или иного элемента структуры.
//
//		Имена полей структуры ДанныеДляОтражения (таблиц значений):
//			НачисленнаяЗарплатаИВзносы
//			НачисленныйНДФЛ
//			УдержаннаяЗарплата
//			ОценочныеОбязательства - эта таблица формируется документом НачислениеОценочныхОбязательствПоОтпускам
//			Депоненты - эта таблица формируется документом Депонирование.
//
//		Структура таблиц значений:
//			НачисленнаяЗарплатаИВзносы.
//				ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//				Подразделение  - СправочникСсылка.ПодразделенияОрганизаций
//				ВидОперации    - ПеречислениеСсылка.ВидыОперацийПоЗарплате
//				СпособОтраженияЗарплатыВБухучете- СправочникСсылка.СпособыОтраженияЗарплатыВБухУчете
//				ОблагаетсяЕНВД - булево
//				ПериодПринятияРасходов - Дата, для учета РБП, определяет месяц, к которому относятся расходы. Передается дата
//				                         начала месяца.
//				ВидНачисленияОплатыТрудаДляНУ - ПеречислениеСсылка.ВидыНачисленийОплатыТрудаДляНУ
//				Сумма - Число 15.2
//				ПФРПоСуммарномуТарифу - Число 15.2
//				ПФРСПревышения - Число 15.2
//				ПФРСтраховая - Число 15.2
//				ПФРНакопительная - Число 15.2
//				ФСС - Число 15.2
//				ФФОМС - Число 15.2
//				ТФОМС - Число 15.2
//				ПФРНаДоплатуЛетчикам - Число 15.2
//				ПФРНаДоплатуШахтерам - Число 15.2
//				ПФРЗаЗанятыхНаПодземныхИВредныхРаботах - Число 15.2
//				ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах - Число 15.2
//				ФССНесчастныеСлучаи - Число 15.2
//				
//			НачисленныйНДФЛ
//				ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//				ВидОперации    - ПеречислениеСсылка.ВидыОперацийПоЗарплате
//				КодПоОКАТО     - Строка, 11
//				КодПоОКТМО     - Строка, 11
//				КПП   - Строка, 9
//				КодНалоговогоОргана - Строка, 4
//				Сумма - Число 15.2
//				
//			УдержаннаяЗарплата
//				ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//				Подразделение  - СправочникСсылка.ПодразделенияОрганизаций
//				ВидОперации    - ПеречислениеСсылка.ВидыОперацийПоЗарплате
//				Контрагент     - СправочникСсылка.Контрагенты, контрагент, в пользу которого произведено удержание.
//				Сумма - Число 15.2
//				
//			ОценочныеОбязательства
//				Подразделение  - СправочникСсылка.ПодразделенияОрганизаций
//				СпособОтраженияЗарплатыВБухучете- СправочникСсылка.СпособыОтраженияЗарплатыВБухУчете
//				СуммаРезерва - Число 15.2
//				СуммаРезерваСтраховыхВзносов - Число 15.2
//				СуммаРезерваНУ - Число 15.2
//				СуммаРезерваСтраховыхВзносовНУ - Число 15.2
//				СуммаРезерваФССНесчастныеСлучаи - Число 15.2
//				СуммаРезерваФССНесчастныеСлучаиНУ - Число 15.2
//                             
Процедура СформироватьДвижения(Движения, Отказ, Организация, МесяцНачисления, ДанныеДляОтражения) Экспорт
	
КонецПроцедуры

