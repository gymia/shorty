<?php
/**
 * Gymia Pre-Job Test
 * URL Shortner
 * Global Functions
 *
 * @author      MarQuis Knox <hire@marquisknox.com>
 * @copyright   2014 MarQuis Knox
 * @link        http://marquisknox.com
 * @license     GNU Affero General Public License
 * @license     http://www.gnu.org/licenses/agpl-3.0.html
 *
 * @since       Wednesday, September 24, 2014, 05:48 AM GMT+1 mknox
 * @edited      $Date$ $Author$
 * @version     $Id$
 * 
 * @category    Functions
 * @package     Gymia Pre-Job Test
*/

/**
 * Truncate a string
 * 
 * @param   string  $string
 * @param   int     $maxChars
 * @return  string
*/
function truncate( $string, $maxChars = MAX_SHORTCODE_LEN )
{
    return substr( $string, 0, $maxChars );    
}